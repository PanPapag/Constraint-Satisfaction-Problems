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
  search(Solution, 0, first_fail, indomain, complete, []).

def_vars(Solution, NoActs, NP) :-
  length(Solution, NoActs),
  Solution #:: 1..NP.

make_tmpl([], [], []).
make_tmpl([activity(A,act(S,E))|RestOfActivities],[Person|RestPeople], [assigned(activity(A,act(S,E)),Person)|Partial]) :-
  make_tmpl(RestOfActivities, RestPeople, Partial).

construct_ASA([], Partial, ASA) :- reverse(Partial,ASA).
construct_ASA([assigned(activity(A,act(_,_)),Person)|RestOfAssignments], Partial, ASA) :-
  construct_ASA(RestOfAssignments, [A - Person|Partial], ASA).

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

constrain(_,S,E,C,ST,[]) :- Dif is E-S, C1 is C+Dif, C1 =< ST.
constrain(Pos,S,E,C,ST,[assigned(activity(_,act(S1,E1)),Y)|Res]) :- Pos #= Y, Dif is E1-S1, C1 is C+Dif, C1 =< ST, E1 < S, constrain(Pos,S,E,C1,ST,Res).
constrain(Pos,S,E,C,ST,[assigned(activity(_,act(S1,E1)),Y)|Res]) :- Pos #= Y, Dif is E1-S1, C1 is C+Dif, C1 =< ST, E < S1, constrain(Pos,S,E,C1,ST,Res).
constrain(Pos,S,E,C,ST,[assigned(activity(_,act(_,_)),Y)|Res]) :- Pos #\= Y, constrain(Pos,S,E,C,ST,Res).
