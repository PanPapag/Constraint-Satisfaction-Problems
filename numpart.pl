:- lib(ic).

numpart(N, SubSet1, SubSet2) :-
  length(Set, N),
  Set #:: 1..N,
  alldifferent(Set),
  append(SubSet1, SubSet2, Set),
  ordered(SubSet1), ordered(SubSet2),
  length(SubSet1, L1), length(SubSet2, L2), eval(L1) #= eval(L2),
  SubSet1 = [First|_], First #= 1,
  get_sum(SubSet1, S1), get_sum(SubSet2, S2),
  get_square_sum(SubSet1, SQ1), get_square_sum(SubSet2, SQ2),
  eval(S1) #= eval(S2),eval(SQ1) #= eval(SQ2),
  search(Set, 0, input_order, indomain_min, complete, []).

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
