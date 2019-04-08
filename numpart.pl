:- lib(fd).

numpart(N, SubSet1, SubSet2) :-
  length(Set, N),
  Set :: 1..N,
  alldifferent(Set),
  append(SubSet1, SubSet2, Set),
  ordered(SubSet1), ordered(SubSet2),
  length(SubSet1, K), length(SubSet2, K),
  SubSet1 = [First|_], First #= 1,
  get_sum(SubSet1, S1), get_sum(SubSet2, S2), S1 #= S2,
  get_square_sum(SubSet1, SQ1), get_square_sum(SubSet2, SQ2), SQ1 #= SQ2,
  generate(Set).

generate([]).
generate(Elements) :-
  deleteffc(Element, Elements, RestElements),
  indomain(Element),
  generate(RestElements).

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
