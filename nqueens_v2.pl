:- lib(fd).

nqueens(N, Solution) :-
  length(Solution, N),
  Solution :: 1..N,
  constrain(Solution),
  generate(Solution).

constrain([]).
constrain([Column|Columns]) :-
  noattack(Column, Columns, 1),
  constrain(Columns).

noattack(_, [], _).
noattack(Column1, [Column2|Columns], Offset) :-
  Column1 ## Column2,
  Column1 ## Column2 - Offset,
  Column1 ## Column2 + Offset,
  NewOffset is Offset + 1,
  noattack(Column1, Columns, NewOffset).

generate([]).
generate([Column|Columns]) :-
  indomain(Column),
  generate(Columns).

go(N, NSols, Time) :-
  cputime(T1),
  findall(Sol, nqueens(N, Sol), Sols),
  cputime(T2),
  length(Sols, NSols),
  Time is T2 - T1.
