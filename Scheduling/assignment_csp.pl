:- lib(ic).
:- lib(listut).
:- [small_activity].
%:- [big_activity].

assignment_csp(NP, ST, ASP, ASA) :-
  findall(activity(A,act(S,E)), activity(A,act(S,E)), Activities),
  length(Activities, NA),
  init_PTS(NP, PTS), init_PTT(NP, PTT),
  def_var(Solution, NP, NA),
  constrain(ST, PTS, PTT, Activities, Solution),
  search(Solution, 0, first_fail, indomain, complete, []),
  construct_ASA(Activities, Solution, ASA).


init_PTS(0, []).
init_PTS(Person, [-1|RTS]) :-
  NPerson is Person - 1,
  init_PTS(NPerson, RTS).

init_PTT(0, []).
init_PTT(Person, [0|RTT]) :-
  NPerson is Person - 1,
  init_PTT(NPerson, RTT).

def_var(S, NP, NA) :-
  length(S, NA),
  S #:: 1..NP.

constrain(_, _, _, [], []).
constrain(ST, PTS, PTT, [activity(_,act(S,E))|RestActivities], [P|RP]) :-
  nth1(P, PTS, TS), S - TS #>= 1, replace(PTS, P, E, NPTS),
  nth1(P, PTT, TT), CTT is TT + E - S, CTT #=< ST, replace(PTT, P, CTT, NPTT),
  constrain(ST, NPTS, NPTT, RestActivities, RP).

replace([_|T], 1, X,[X|T]).
replace([H|T], I, X, [H|R]) :-
  I1 is I - 1,
  replace(T, I1, X, R).

construct_ASA([], [], []).
construct_ASA([activity(A,act(_,_))|RestActivities], [P|RP], [A - P|RestASA]) :-
  construct_ASA(RestActivities, RP, RestASA).
