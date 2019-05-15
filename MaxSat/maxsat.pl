:- lib(ic).
:- lib(branch_and_bound).
:- lib(listut).
:- [create_formula].

maxsat(NV, NC, D, F, S, M) :-
  create_formula(NV, NC, D, F),
  def_vars(TempS, NV),
  make_FSList(F, TempS, FS), !,
  evaluate_all_clauses(FS, EV),
  Cost #= -sum(EV),
  bb_min(search(TempS, 0, first_fail, indomain_middle, complete, []), Cost, _),
  fix_S(TempS, S),
  count_true_clauses(FS, ListM),
  sum_list(ListM, M).

def_vars(S ,NV) :-
  length(S, NV),
  S #:: [-1,1].

make_FSList([], _, []).
make_FSList([HeadF|TailF], S, [NewFS|RemFS]) :-
  make_sub_FSList(HeadF, S, NewFS),
  make_FSList(TailF, S, RemFS).

make_sub_FSList([], _, []).
make_sub_FSList([HeadSubF|TailSubF], S, [Sign - InS | RemSubFS]) :-
  abs(HeadSubF, AbsHeadSubF),
  get_sign(HeadSubF, AbsHeadSubF, Sign),
  nth1(AbsHeadSubF, S, InS),
  make_sub_FSList(TailSubF, S, RemSubFS).

get_sign(Element, Element, 1).
get_sign(_, _, -1).

evaluate_all_clauses([], []).
evaluate_all_clauses([HeadFS|TailFS], [EVClause|RemClauses]) :-
  evaluate_clause(HeadFS, EVClause),
  evaluate_all_clauses(TailFS, RemClauses).

evaluate_clause([], -1).
evaluate_clause([Sign - Value|TailC], Sign*Value+EV) :-
  evaluate_clause(TailC, EV).

fix_S([], []).
fix_S([-1|TailTempS], [0|TailS]) :- fix_S(TailTempS, TailS).
fix_S([1|TailTempS], [1|TailS]) :- fix_S(TailTempS, TailS).

count_true_clauses([], []).
count_true_clauses([HeadFS|TailFS], [EV|EVRes]) :-
  final_evaluation(HeadFS, EV),
  count_true_clauses(TailFS, EVRes).

final_evaluation([], 0).
final_evaluation([-1 - -1|_], 1).
final_evaluation([-1 - 1|TailClause], Res) :- final_evaluation(TailClause, Res).
final_evaluation([1 - 1|_], 1).
final_evaluation([1 - -1|TailClause], Res) :- final_evaluation(TailClause, Res).

sum_list([], 0).
sum_list([H|T], Sum) :-
   sum_list(T, Rest),
   Sum is H + Rest.
