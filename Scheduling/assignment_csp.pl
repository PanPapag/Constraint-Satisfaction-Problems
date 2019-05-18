:- lib(ic).
:- lib(swi).
:- [small_activity].
%:- [big_activity].

assignment_csp(NP, ST, ASP, ASA) :-
  findall(activity(A,act(S,E)), activity(A,act(S,E)), Activities),
  length(Activities, NA),
  def_var(Solution, NP, NA),
  constrain(Activities, Solution),
  search(Solution, 0, first_fail, indomain, complete, []).


constrain([], []).


def_var(S, NP, NA) :-
  length(S, NA),
  S #:: 1..NP.
