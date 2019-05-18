:- lib(ic).
:- [small_activity].
%:- [big_activity].

assignment_csp(NP, ST, ASP, ASA) :-
  findall(activity(A,act(S,E)), activity(A,act(S,E)), Activities), writeln(Activities),
  findall(X, between(1, NP, X), Persons), writeln(Persons),
  make_tmpl(Activities, Assignments),  writeln(Assignments).

make_tmpl([activity(A,act(S,E))], [assigned(activity(A,act(S,E)),_)]).
make_tmpl([activity(A,act(S,E))|RestOfActivities], [assigned(activity(A,act(S,E)),_)|Partial]) :-
  make_tmpl(RestOfActivities, Partial).


calculate_total_time([], 0).
calculate_total_time([activity(_,act(PS,PE))|RestOfPersonActivities], CT) :-
  calculate_total_time(RestOfPersonActivities, RCT),
  CT is PE - PS + RCT.
  
construct_ASA([], Partial, ASA) :- reverse(Partial,ASA).
construct_ASA([assigned(activity(A,act(_,_)),Person)|RestOfAssigments], Partial, ASA) :-
  construct_ASA(RestOfAssigments, [A - Person|Partial], ASA).

construct_ASP([], _, Partial, ASP) :- reverse(Partial,ASP).
construct_ASP([Person|RestOfPersons], Assigments, Partial, ASP) :-
  findall(PA,member(assigned(activity(PA,act(PS,PE)),Person),Assigments), OnlyPersonActivities),
  findall(activity(PA,act(PS,PE)), member(assigned(activity(PA,act(PS,PE)),Person),Assigments), PersonActivities),
  calculate_total_time(PersonActivities, TT),
  construct_ASP(RestOfPersons, Assigments, [Person - OnlyPersonActivities - TT|Partial], ASP).

reverse(L, R) :- reverse_app(L, [], R).
reverse_app([], R, R).
reverse_app([H|L], SoFar, R) :- reverse_app(L, [H|SoFar], R).

between(I, J, I) :- I =< J.
between(I, J, X) :-
   I < J,
   I1 is I+1,
   between(I1, J, X).
