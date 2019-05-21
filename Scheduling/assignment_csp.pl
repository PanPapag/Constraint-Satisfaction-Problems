:- lib(ic).
:- lib(listut).
:- [small_activity].
%:- [big_activity].

assignment_csp(NP, ST, ASP, Solution) :-
  findall(activity(A,act(S,E)), activity(A,act(S,E)), Activities),               % extract all activities into a list
  length(Activities, NA),                                                        % get number of activities
  init_TS(NP, LTS),                                                              % at start each person has a time stamp equals -1
  def_var(Solution, NP, NA), writeln(Activities),
  %constrain(Activities, LTS, Solution),
  search(Solution, 0, first_fail, indomain, complete, []).

init_TS(0, []).
init_TS(RP, [-1|RTS]) :-
  NRP is RP - 1,
  init_TS(NRP, RTS).

def_var(S, NP, NA) :-
  length(S, NA),
  S #:: 1..NP.

constrain([], _, []).
constrain([activity(A,act(S,E))|RestActivities], LTS, [P|RP]) :-

  constrain(RestActivities, NLTS, RP).
