#############################################################################
##
## holonomy.gd           SgpDec package
##
## Copyright (C) 2008-2012
## Attila Egri-Nagy, Chrystopher L. Nehaniv, James D. Mitchell
##
## A hierarchical decomposition: Holonomy coordinatization of semigroups.
##

DeclareProperty("IsHolonomyCascadeSemigroup",IsCascadeSemigroup);

DeclareGlobalFunction("PermutationResetSemigroup");
DeclareGlobalFunction("ShiftGroupAction");

DeclareGlobalFunction("GroupComponentsOnDepth");
DeclareGlobalFunction("Coordinates");
DeclareGlobalFunction("CoverChain");
DeclareGlobalFunction("ChangeCoveredSet");
DeclareGlobalFunction("HolonomyInts2Sets");
DeclareGlobalFunction("HolonomySets2Ints");
DeclareGlobalFunction("AllHolonomyLifts");
DeclareGlobalFunction("Interpret");
DeclareGlobalFunction("HolonomyDecomposition");
#to store it on HolonomyCascade
DeclareAttribute("HolonomyDecompositionOf",IsHolonomyCascadeSemigroup);
DeclareGlobalFunction("HolonomyComponentActions");
DeclareGlobalFunction("HolonomyDependencies");
DeclareGlobalFunction("HolonomyCascadeSemigroup");

DeclareInfoClass("HolonomyInfoClass");
