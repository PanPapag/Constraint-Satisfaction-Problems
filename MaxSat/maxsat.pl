:- lib(ic).
:- lib(branch_and_bound).

maxsat(NV, NC, D, F, S, M) :-
  create_formula(NV, NC, D, F),
  def_vars(S, NV).

def_vars(S ,NV) :-
  length(S, NV),
  S #:: 0..1.
