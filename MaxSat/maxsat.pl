:- lib(ic).
:- lib(branch_and_bound).
:- lib(listut).
:- [create_formula].

maxsat(NV, NC, D, F, S, M) :-
  create_formula(NV, NC, D, F),
  def_vars(S, NV),
  make_FSList(F, S, FS), !,
  evaluate_all_clauses(FS, EV),
  Cost #= -sum(EV),
  bb_min(search(S, 0, first_fail, indomain_middle, complete, []), Cost, _),
  count_true_clauses(FS, M).

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
