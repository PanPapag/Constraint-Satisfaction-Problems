:- lib(ic).
:- lib(branch_and_bound).
:- [create_formula].

maxsat(NV, NC, D, F, S, -Cost) :-
  create_formula(NV, NC, D, F),
  def_vars(S, NV),
  compute_costlist(F, S, CostList),
  Cost #= -sum(CostList),
  bb_min(search(S, 0, input_order, indomain, complete, []), Cost, _).

def_vars(S, NV) :-
  length(S, NV),
  S #:: 0..1.

get_val(1,[X|_],X) :- !.
get_val(Idx,[_|List],X) :- Idx > 1, Idx1 is Idx-1, get_val(Idx1,List,X).

evaluate_all_clauses([],_,[]).
evaluate_all_clauses([HeadF|TailF], S, [K|CostList]) :-
  clause_evaluation(HeadF, S, EV),
  evaluate_all_clauses(TailF, S, CostList).

clause_evaluation([],_,[]).
clause_evaluation([H|T], S, [X|Res]) :- H>0, abs(H,AbsH), get_val(AbsH,S,Val), X#=Val, clause_evaluation(T,S,Res).
clause_evaluation([H|T], S, [X|Res]) :- H<0, abs(H,AbsH), get_val(AbsH,S,Val), X#\=Val, clause_evaluation(T,S,Res).
