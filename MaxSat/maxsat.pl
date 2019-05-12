:- lib(ic).
:- lib(branch_and_bound).
:- lib(listut).

maxsat(NV, NC, D, F, S, M) :-
  create_formula(NV, NC, D, F),
  def_vars(S, NV),
  make_FSList(F, S, FS), writeln(FS),
  get_false_clauses(FS, FC),
  Cost #= FC,
  bb_min(search(S, 0, input_order, indomain, complete, []), Cost, _),
  M is NC - FC.

def_vars(S ,NV) :-
  length(S, NV),
  S #:: 0..1.

make_FSList([], _, []).
make_FSList([HeadF|TailF], S, [NewFS|RemFS]) :-
  make_sub_FSList(HeadF, S, NewFS),
  make_FSList(TailF, S, RemFS).

make_sub_FSList([], _, []).
make_sub_FSList([HeadSubF|TailSubF], S, [Sign - IsInS | RemSubFS]) :-
  abs(HeadSubF, AbsHeadSubF),
  get_sign(HeadSubF, AbsHeadSubF, Sign),
  nth1(AbsHeadSubF, S, IsInS),
  make_sub_FSList(TailSubF, S, RemSubFS).

get_sign(Element, Element, 1) :- !.
get_sign(_, _, 0).

get_false_clauses([], 0).
get_false_clauses([HeadFS|TailFS], FC) :-
  % At least one element of HeadFS is True
  get_false_clauses(TailFS, NFC),
  FC is NFC + 1.
