:-lib(ic).
:-lib(listut).

activity(a01, act(0,3)).
activity(a02, act(0,4)).
activity(a03, act(1,5)).
activity(a04, act(4,6)).
activity(a05, act(6,8)).
activity(a06, act(6,9)).
activity(a07, act(9,10)).
activity(a08, act(9,13)).
activity(a09, act(11,14)).
activity(a10, act(12,15)).
activity(a11, act(14,17)).
activity(a12, act(16,18)).
activity(a13, act(17,19)).
activity(a14, act(18,20)).
activity(a15, act(19,20)).



assignment_csp(NP,ST,ASP,ASA) :- findall(A,activity(A,_),Activities),
                              length(Activities,NActs),
                              N is NActs+1,
                              length(Sol,NActs),
                              make_template1(Activities,Sol,ASA),
                              Sol #:: 1..NP.
                              assign(NP,N,ST,ASA),
                              search(Sol,0,first_fail,indomain,complete,[]).

fit(_,S,E,C,ST,[]) :- Dif is E-S, C1 is C+Dif, C1 =< ST.
fit(Pos,S,E,C,ST,[X-Y|Res]) :- Pos #= Y, activity(X,act(S1,E1)), Dif is E1-S1, C1 is C+Dif, C1 =< ST, E1 < S, fit(Pos,S,E,C1,ST,Res).
fit(Pos,S,E,C,ST,[X-Y|Res]) :- Pos #= Y, activity(X,act(S1,E1)), Dif is E1-S1, C1 is C+Dif, C1 =< ST, E < S1, fit(Pos,S,E,C1,ST,Res).
fit(Pos,S,E,C,ST,[_-Y|Res]) :- Pos #\= Y, fit(Pos,S,E,C,ST,Res).

assign(_,1,_,[]).
assign(NP,Curr,ST,[Act-Pos|Res]) :- assign(NP,C,ST,Res), Curr is C+1, C >= NP, activity(Act,act(S,E)), fit(Pos,S,E,0,ST,Res).
assign(NP,Curr,ST,[Act-X|Res]) :- assign(NP,C,ST,Res), Curr is C+1, C < NP, X #= C, activity(Act,act(S,E)), fit(C,S,E,0,ST,Res).

make_template1([],[],[]).
make_template1([Act|Activities],[P|NP],[Act-P|Res]) :- make_template1(Activities,NP,Res).
