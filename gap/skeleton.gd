#############################################################################
##
## skeleton.gd           SgpDec package
##
## Copyright (C) 2010-2013
##
## Attila Egri-Nagy, Chrystopher L. Nehaniv, James D. Mitchell
##
## Skeleton of the semigroup action on a set. Subduction relation,
## equivalence classes, tilechains.
##

DeclareCategory("IsSkeleton", IsObject and IsAttributeStoringRep);
BindGlobal("SkeletonFamily",NewFamily("SkeletonFamily", IsSkeleton));
BindGlobal("SkeletonType", NewType(SkeletonFamily,IsSkeleton));

#constructor
DeclareGlobalFunction("Skeleton");

#stored attributes
DeclareAttribute("TransSgp",IsSkeleton);
DeclareAttribute("BaseSet",IsSkeleton);
DeclareAttribute("Generators",IsSkeleton);
DeclareAttribute("DegreeOfSkeleton",IsSkeleton);
DeclareAttribute("Singletons",IsSkeleton);
DeclareAttribute("ForwardOrbit",IsSkeleton);
DeclareAttribute("SkeletonTransversal",IsSkeleton);
DeclareAttribute("ExtendedImageSet",IsSkeleton);
DeclareAttribute("InclusionCoverBinaryRelation",IsSkeleton);
DeclareAttribute("RepSubductionCoverBinaryRelation",IsSkeleton);
DeclareAttribute("Depths",IsSkeleton);
DeclareAttribute("DepthOfSkeleton",IsSkeleton);
DeclareAttribute("Heights",IsSkeleton);
DeclareAttribute("RepresentativeSets",IsSkeleton);
PartialOrbits := NewAttribute("PartialOrbits",IsSkeleton,"mutable");
#TODO make it readonly

#functions
DeclareGlobalFunction("TilesOf");
DeclareGlobalFunction("DepthOfSet");
DeclareGlobalFunction("RepresentativeSet");
DeclareGlobalFunction("RandomTileChain");
DeclareGlobalFunction("AllTileChainsToSet");
DeclareGlobalFunction("AllTileChains");
DeclareGlobalFunction("NumberOfTileChainsToSet");
DeclareGlobalFunction("IsSubductionEquivalent");
DeclareGlobalFunction("IsSubductionLessOrEquivalent");
DeclareGlobalFunction("SubductionWitness");
DeclareGlobalFunction("ImageWitness");
DeclareGlobalFunction("SkeletonClassOfSet");
DeclareGlobalFunction("SkeletonClasses");
DeclareGlobalFunction("SkeletonClassesOnDepth");
DeclareGlobalFunction("DotSkeleton");

DeclareInfoClass("SkeletonInfoClass");

#EXPERIMENTAL
DeclareGlobalFunction("WeakControlWords");
