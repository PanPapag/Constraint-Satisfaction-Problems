:- lib(ic).
:- lib(branch_and_bound).
:- [create_formula].

maxsat(NV, NC, D, F, S, M) :-
  create_formula(NV, NC, D, F),
  def_vars(S, NV),
  evaluate_all_clauses(F,S,CostList),
  Cost #= -sum(CostList),
  M #= -Cost,
  bb_min(search(S, 0, input_order, indomain, complete, []), Cost, _).

def_vars(S, NV) :-
  length(S, NV),
  S #:: 0..1.

get_max([], X) :- X #= 0, !.
get_max(L, X) :- maxlist(L, X).

get_val(1,[X|_],X) :- !.
get_val(Idx,[_|List],X) :- Idx > 1, Idx1 is Idx-1, get_val(Idx1,List,X).

evaluate_all_clauses([], _, []).
evaluate_all_clauses([HeadF|TailF], S, [EVC|CostList]) :-
  clause_eval(HeadF, S, EVList),
  get_max(EVList, EVC),
  evaluate_all_clauses(TailF, S, CostList).

clause_evaluation([],_,[]).
clause_evaluation([HeadC|TailC], S, [X|Res]) :-
  HeadC > 0, abs(HeadC, AbsHeadC),
  get_val(AbsHeadC, S, Value), X #= Value,
  clause_evaluation(TailC, S, Res).
clause_evaluation([HeadC|TailC], S, [X|Res]) :-
  HeadC < 0, abs(HeadC, AbsHeadC),
  get_val(AbsHeadC, S, Value), X #\= Value,
  clause_evaluation(TailC, S, Res).
