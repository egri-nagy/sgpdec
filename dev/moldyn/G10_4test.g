Read("slowmolhists.g");
Read("../uldg/uldg.g");

gens := TransformationsFromElementaryCollapsings(GammaGraph(10,4),10);;
for i in [1..33] do 
  howmany_permutations(gens,FiniteSet([1,2,3,4,5,6,7,8,9]),i);
od;
