:- lib(ic).
:- [small_activity].
%:- [big_activity].

assignment_csp(NP, ST, ASP, ASA) :-
  findall(activity(A,act(S,E)), activity(A,act(S,E)), Activities),
  findall(X, between(1, NP, X), Persons),
  length(Activities, NoActs),
  def_vars(Solution, NoActs, NP),
  make_tmpl(Activities, Solution, Assigments),
  %assignment_aux(NoActs, NP, ST, Assigments),
  construct_ASA(Assigments, [], ASA), nl.
  %construct_ASP(Persons, Assigments, [], ASP), nl.
  %search(Solution, 0, first_fail, indomain, complete, []).

def_vars(Solution, NoActs, NP) :-
  length(Solution, NoActs),
  Solution #:: 1..NP.

assignment_aux(_, _, _, []).
assignment_aux(Position, NP, ST, [assigned(activity(_,act(S,E)),Person)|Others]) :-
  NewPosition is Position - 1,
  assignment_aux(NewPosition, NP, ST, Others),
  fix(Position, NP, Person),
  available(ST, S, E, Others, Person).

fix(Position, NP, Position) :- Position < NP.
fix(Position, NP, _) :- Position >= NP.

available(ST, S, E, Assignments, Person) :-
  findall(activity(PA,act(PS,PE)),member(assigned(activity(PA,act(PS,PE)),Person),Assignments), PersonActivities),
  check_time_confictions(S, E, PersonActivities),
  calculate_total_time(PersonActivities, CT),
  CT + E - S =< ST.

check_time_confictions(_, _, []).
check_time_confictions(S, E, [activity(_,act(_,PE))|RestOfPersonActivities]) :-
  S - PE >= 1,
  check_time_confictions(S, E, RestOfPersonActivities).
check_time_confictions(S, E, [activity(_,act(PS,_))|RestOfPersonActivities]) :-
  PS - E >= 1,
  check_time_confictions(S, E, RestOfPersonActivities).

calculate_total_time([], 0).
calculate_total_time([activity(_,act(PS,PE))|RestOfPersonActivities], CT) :-
  calculate_total_time(RestOfPersonActivities, RCT),
  CT is PE - PS + RCT.

make_tmpl([], [], []).
make_tmpl([activity(A,act(S,E))|RestOfActivities],[Person|RestPeople], [assigned(activity(A,act(S,E)), Person)|Partial]) :-
  make_tmpl(RestOfActivities, RestPeople, Partial).

construct_ASA([], Partial, ASA) :- reverse(Partial,ASA).
construct_ASA([assigned(activity(A,act(_,_)),Person)|RestOfAssigments], Partial, ASA) :-
  construct_ASA(RestOfAssigments, [A - Person|Partial], ASA).

construct_ASP([], _, Partial, ASP) :- reverse(Partial,ASP).
construct_ASP([Person|RestOfPersons], Assigments, Partial, ASP) :-
  findall(PA,member(assigned(activity(PA,act(PS,PE)),Person),Assigments), OnlyPersonActivities),
  findall(activity(PA,act(PS,PE)), member(assigned(activity(PA,act(PS,PE)),Person),Assigments), PersonActivities),
  calculate_total_time(PersonActivities, TT),
  construct_ASP(RestOfPersons, Assigments, [Person - OnlyPersonActivities - TT|Partial], ASP).


between(I, J, I) :- I =< J.
between(I, J, X) :-
   I < J,
   I1 is I+1,
   between(I1, J, X).
