:- lib(ic).
:- lib(branch_and_bound).
:- [small_activity].
%:- [big_activity].

assignment_csp(NP, ST, ASP, ASA) :-
  findall(activity(A,act(S,E)), activity(A,act(S,E)), Activities),
  findall(X, between(1, NP, X), Persons),
  length(Activities, NoActs),
  def_vars(Solution, NoActs, NP),
  make_tmpl(Activities, Solution, Assignments),
  compute_A(NP, Activities, A),
  assignment_aux(NoActs, NP, ST, A, Assignments, Costlist), writeln(Costlist),
  construct_ASA(Assignments, [], ASA),
  construct_ASP(Persons, Assignments, [], ASP), nl,
  %bb_min(search(Solution, 0, first_fail, indomain, complete, []), Cost, _).
  search(Solution, 0, first_fail, indomain, complete, []).

def_vars(Solution, NoActs, NP) :-
  length(Solution, NoActs),
  Solution #:: 1..NP.

make_tmpl([], [], []).
make_tmpl([activity(A,act(S,E))|RestOfActivities], [Person|RestPeople], [assigned(activity(A,act(S,E)),Person)|Partial]) :-
  make_tmpl(RestOfActivities, RestPeople, Partial).

assignment_aux(_, _, _, _, [], []).
assignment_aux(Position, NP, ST, A, [assigned(activity(_,act(S,E)),Person)|Others], Costlist) :-
  NewPosition is Position - 1,
  assignment_aux(NewPosition, NP, ST, A, Others, Costlist),
  Position < NP, Person #= Position,
  constrain(Position, S, E, 0, ST, Others).
assignment_aux(Position, NP, ST, A, [assigned(activity(_,act(S,E)),Person)|Others], Costlist) :-
  NewPosition is Position - 1,
  assignment_aux(NewPosition, NP, ST, A, Others, Costlist),
  Position >= NP,
  constrain(Person, S, E, 0, ST, Others).

constrain(_, S, E, CST, ST, []) :-
  Duration is E - S,
  CST1 is CST + Duration, CST1 =< ST.
constrain(Person, S, E, CST, ST, [assigned(activity(_,act(_,_)),Selected)|Others]) :-
  Person #\= Selected,
  constrain(Person, S, E, CST, ST, Others).
constrain(Person, S, E, CST, ST, [assigned(activity(_,act(S1,E1)),Selected)|Others]) :-
  Person #= Selected,
  Duration is E1 - S1, E < S1,
  CST1 is CST + Duration, CST1 =< ST,
  constrain(Person, S, E, CST1, ST, Others).
constrain(Person, S, E, CST, ST, [assigned(activity(_,act(S1,E1)),Selected)|Others]) :-
  Person #= Selected,
  Duration is E1 - S1, E1 < S,
  CST1 is CST + Duration, CST1 =< ST,
  constrain(Person, S, E, CST1, ST, Others).

construct_ASA([], Partial, ASA) :- reverse(Partial,ASA).
construct_ASA([assigned(activity(A,act(_,_)),Person)|RestOfAssignments], Partial, ASA) :-
  construct_ASA(RestOfAssignments, [A - Person|Partial], ASA).

construct_ASP([], _, Partial, ASP) :- reverse(Partial,ASP).
construct_ASP([Person|RestOfPersons], Assigments, Partial, ASP) :-
  findall(PA,member(assigned(activity(PA,act(PS,PE)),Person),Assigments), OnlyPersonActivities),
  findall(activity(PA,act(PS,PE)), member(assigned(activity(PA,act(PS,PE)),Person),Assigments), PersonActivities),
  calculate_total_time(PersonActivities, TT),
  construct_ASP(RestOfPersons, Assigments, [Person - OnlyPersonActivities - TT|Partial], ASP).

calculate_total_time([], 0).
calculate_total_time([activity(_,act(PS,PE))|RestOfPersonActivities], CT) :-
  calculate_total_time(RestOfPersonActivities, RCT),
  CT is PE - PS + RCT.

compute_A(NP, Activities, A) :-
  compute_D(Activities, 0, D),
  D_A is D / NP,
  A is round(D_A).

compute_D([], D, D).
compute_D([activity(_,act(S,E))|Res], C, D) :-
  Duration is E - S,
  C1 is C + Duration,
  compute_D(Res, C1, D).

between(I, J, I) :- I =< J.
between(I, J, X) :-
  I < J,
  I1 is I+1,
  between(I1, J, X).
