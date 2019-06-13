:- lib(ic).
:- [small_activity].
%:- [big_activity].

assignment_csp(NP, ST, ASP, ASA) :-
  findall(activity(A,act(S,E)), activity(A,act(S,E)), Activities),
  length(Activities, NoActs),
  def_vars(Solution, NoActs, NP),
  make_tmpl(Activities, Solution, Assignments),
  assignment_aux(NoActs, NP, ST, Assignments),
  construct_ASA(Assignments, [], ASA), nl,
  compute_A(NP, Activities, A),
  search(Solution, 0, first_fail, indomain, complete, []).

def_vars(Solution, NoActs, NP) :-
  length(Solution, NoActs),
  Solution #:: 1..NP.

make_tmpl([], [], []).
make_tmpl([activity(A,act(S,E))|RestOfActivities],[Person|RestPeople], [assigned(activity(A,act(S,E)),Person)|Partial]) :-
  make_tmpl(RestOfActivities, RestPeople, Partial).

assignment_aux(_, _, _, []).
assignment_aux(Position, NP, ST, [assigned(activity(_,act(S,E)),Person)|Others]) :-
  NewPosition is Position - 1,
  assignment_aux(NewPosition, NP, ST, Others),
  Position < NP, Person #= Position,
  constrain(Position, S, E, 0, ST, Others).
assignment_aux(Position, NP, ST, [assigned(activity(_,act(S,E)),Person)|Others]) :-
  NewPosition is Position - 1,
  assignment_aux(NewPosition, NP, ST, Others),
  Position >= NP,
  constrain(Person, S, E, 0, ST, Others).

constrain(_, S, E, CST, ST, []) :-
  Duration is E - S,
  CST1 is CST + Duration, CST1 =< ST.
constrain(Person, S, E, CST, ST,[assigned(activity(_,act(_,_)),Selected)|Others]) :-
  Person #\= Selected,
  constrain(Person, S, E, CST, ST, Others).
constrain(Person, S, E, CST, ST, [assigned(activity(_,act(S1,E1)),Selected)|Others]) :-
  Person #= Selected,
  Duration is E1 - S1, E < S1,
  CST1 is CST + Duration, CST1 =< ST,
  constrain(Person, S, E, CST1, ST, Others).
constrain(Person, S, E, CST, ST,[assigned(activity(_,act(S1,E1)),Selected)|Others]) :-
  Person #= Selected,
  Duration is E1 - S1, E1 < S,
  CST1 is CST + Duration, CST1 =< ST,
  constrain(Person, S, E, CST1, ST, Others).

construct_ASA([], Partial, ASA) :- reverse(Partial,ASA).
construct_ASA([assigned(activity(A,act(_,_)),Person)|RestOfAssignments], Partial, ASA) :-
  construct_ASA(RestOfAssignments, [A - Person|Partial], ASA).


compute_A(NP, Activities, A) :-
  compute_D(Activities, 0, D),
  D_A is D / NP,
  A is round(D_A).

compute_D([], D, D).
compute_D([activity(_,act(S,E))|Res], C, D) :-
  Duration is E - S,
  C1 is C + Duration,
  compute_D(Res, C1, D).
