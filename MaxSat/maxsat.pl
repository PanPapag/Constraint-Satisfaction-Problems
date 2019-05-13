:- lib(ic).
:- lib(branch_and_bound).
:- lib(listut).

maxsat(NV, NC, D, F, S, M) :-
  create_formula(NV, NC, D, F),
  def_vars(S, NV),
  make_FSList(F, S, FS), writeln(FS),
  get_false_clauses(FS, 0, FC),
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

get_false_clauses([], FC, FC).
get_false_clauses([HeadFS|TailFS], MFC, FC) :-
  % A clause is true if and only if at least one element of the clause is true
  % In case of zero true statements, the clase is false
  writeln(HeadFS),
  evaluate_clause(HeadFS, TS),
  NFC is MFC + 1,
  get_false_clauses(TailFS, NFC, FC).

evaluate_clause([], 0).
evaluate_clause([HeadClause|TailClause], TS) :-
  is_true(HeadClause),
  evaluate_clause(TailClause, NTS),
  TS is NTS + 1.

is_true(Sign - Value) :- Sign + Value #>= 1.

create_formula(NVars, NClauses, Density, Formula) :-
   formula(NVars, 1, NClauses, Density, Formula).

formula(_, C, NClauses, _, []) :-
   C > NClauses.
formula(NVars, C, NClauses, Density, [Clause|Formula]) :-
   C =< NClauses,
   one_clause(1, NVars, Density, Clause),
   C1 is C + 1,
   formula(NVars, C1, NClauses, Density, Formula).

one_clause(V, NVars, _, []) :-
   V > NVars.
one_clause(V, NVars, Density, Clause) :-
   V =< NVars,
   rand(1, 100, Rand1),
   (Rand1 < Density ->
      (rand(1, 100, Rand2),
       (Rand2 < 50 ->
        Literal is V ;
        Literal is -V),
       Clause = [Literal|NewClause]) ;
      Clause = NewClause),
   V1 is V + 1,
   one_clause(V1, NVars, Density, NewClause).

rand(N1, N2, R) :-
   random(R1),
   R is R1 mod (N2 - N1 + 1) + N1.
