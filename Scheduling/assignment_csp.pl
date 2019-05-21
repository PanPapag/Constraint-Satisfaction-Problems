:- lib(ic).
:- lib(listut).
:- [small_activity].
%:- [big_activity].

assignment_csp(NP, ST, ASP, Solution) :-
  findall(activity(A,act(S,E)), activity(A,act(S,E)), Activities),              
  length(Activities, NA),
  init_TS(NP, PTS),
  def_var(Solution, NP, NA),
  constrain(ST, PTS, Activities, Solution),
  search(Solution, 0, first_fail, indomain, complete, []).

init_TS(0, []).
init_TS(RP, [-1|RTS]) :-
  NRP is RP - 1,
  init_TS(NRP, RTS).

def_var(S, NP, NA) :-
  length(S, NA),
  S #:: 1..NP.

constrain(_, _, [], []).
constrain(ST, PTS, [activity(_,act(S,E))|RestActivities], [P|RP]) :-
  nth1(P, PTS, TS), S - TS #>= 1,
  replace(PTS, P, S, NPTS),
  constrain(ST, NPTS, RestActivities, RP).

replace([_|T], 1, X,[X|T]).
replace([H|T], I, X, [H|R]) :-
  I1 is I - 1,
  replace(T, I1, X, R).
