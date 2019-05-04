:- lib(ic).

% Assume all values mutipled by 100
seven_eleven(Objects) :-
  Objects = [A, B, C, D],
  Objects #:: [1..711],
  A * B * C * D #= 711000000,
  A + B + C + D #= 711,
  A #=< B,
  B #=< C,
  C #=< D,
  search(Objects, 0, largest, indomain_split, complete, []).
