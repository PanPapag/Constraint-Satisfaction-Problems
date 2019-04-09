:- lib(ic).

numpart(N, SubSet1, SubSet2) :-
  length(Set, N),
  SubSetLength is N // 2,
  SubSetSum is (N * (N + 1)) // 4,
  SubSetSquareSum is (N * (N + 1) * (2*N + 1)) // 12,
  Set #:: 1..N,
  alldifferent(Set),
  append(SubSet1, SubSet2, Set),
  ordered(SubSet1), ordered(SubSet2),
  length(SubSet1, L1), length(SubSet2, L2),
  eval(L1) #= SubSetLength,
  eval(L2) #= SubSetLength,
  SubSet1 = [First|_], First #= 1,
  get_sum(SubSet1, S1), get_sum(SubSet2, S2),
  get_square_sum(SubSet1, SQ1), get_square_sum(SubSet2, SQ2),
  eval(SQ1) #= SubSetSquareSum, eval(SQ2) #= SubSetSquareSum,
  eval(S1) #= SubSetSum, eval(S2) #= SubSetSum,
  search(Set, 0, largest, indomain_max, complete, []).

get_sum([], 0).
get_sum([H|T], Sum + H) :-
  get_sum(T, Sum).

get_square_sum([], 0).
get_square_sum([H|T], Sum + H * H) :-
  get_square_sum(T, Sum).

ordered([]).
ordered([_]).
ordered([H1,H2|T]) :-
  H1 #< H2,
  ordered([H2|T]).
