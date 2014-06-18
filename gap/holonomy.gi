#############################################################################
##
## holonomy.gi           SgpDec package
##
## Copyright (C) 2010-2012
##
## Attila Egri-Nagy, Chrystopher L. Nehaniv, James D. Mitchell
##
## A hierarchical decomposition: Holonomy coordinatization of semigroups.
##

################################################################################
# CODING OF THE HOLONOMY COMPONENT STATES ######################################

# CODEC: INTEGERS <--> SETS
# Though the coordinate values are elements of the cover of a representative,
# it still has to be converted to integers

# figures out that which slot its representative belongs to (on the same level)
GetSlot := function(set,sk)
  return Position(RepresentativeSets(sk)[DepthOfSet(sk,set)],
                 RepresentativeSet(sk,set));
end;

# decoding: integers -> sets, integers simply code the positions sk.coordvals
InstallGlobalFunction(HolonomyInts2Sets,
function(sk, ints)
local sets, level;
  sets := ListWithIdenticalEntries(Length(ints),0); #default: 0 (jumped over)
  for level in [1..Length(ints)] do
    if ints[level] > 0 then
      # the set at the position coded by the integer
      sets[level] := CoordVals(sk)[level][ints[level]];
    fi;
  od;
  return sets;
end);

# encoding: sets -> integers, we need to find the set in the right slot
InstallGlobalFunction(HolonomySets2Ints,
function(sk, sets)
local set,level,ints,slot;
  set := BaseSet(sk);
  ints := ListWithIdenticalEntries(Length(sets),0); #default: 0 (jumped over)
  for level in [1..Length(sets)] do
    if sets[level] <> 0 then
      slot := GetSlot(set, sk); #TODO how can we make sure about the right slot?
      ints[level] := Position(CoordVals(sk)[level],
                             sets[level],
                             Shifts(sk)[level][slot]);
      set := sets[level];
    fi;
  od;
  return ints;
end);

#####
# CHAIN <-> COORDINATES
# sets (tiles of representative sets) -> elements of a tile chain
# moving between the encoded set and the representative

# basically the following 2 functions are iterated to choose a set from the
# tiles of a representative set or another equivalent set

#we map  a representative tile to a tile of P
RealTile := function(reptile, P, skeleton)
  return OnFiniteSet(reptile , FromRep(skeleton, P));
end;

#we map  a tile of P to a tile of Rep(P)
RepTile := function(realtile, P, skeleton)
  return OnFiniteSet(realtile , ToRep(skeleton, P));
end;

# decoding: set coordinate values -> tile chain
InstallGlobalFunction(DecodeCoords,
        function(sk, coordinates)
  local chain,P,depth;
  chain := [];
  depth := 1;
  P := BaseSet(sk); #we start to approximate from the top set
  while depth < DepthOfSkeleton(sk) do
    #we go from the cover of the rep to the cover of the chain element
    P := RealTile(coordinates[depth],P,sk);
    Add(chain,P);
    depth :=  DepthOfSet(sk,P);
  od;
  return chain;
end);

# encoding: tile chain -> set coordinate values
InstallGlobalFunction(EncodeTileChain,
        function(sk, chain)
  local sets,i, P;
  #filling up with zeros - jumped over levels are abstract
  sets := ListWithIdenticalEntries(DepthOfSkeleton(sk)-1, 0);
  P := BaseSet(sk);
  #the chain can be shorter (already jumped over), so it is OK go strictly by i
  for i in [1..Length(chain)] do
    sets[DepthOfSet(sk, P)] := RepTile(chain[i], P, sk);
    P := chain[i];
  od;
  return sets;
end);

################################################################################
# IMPLEMENTED METHODS FOR ABSTRACT DECOMPOSITION ###############################
InstallGlobalFunction(Interpret,
        function(sk,level,state)
  return CoordVals(sk)[level][state];
end);
#AsPoint
AsHolonomyPoint :=
  #    "flatten a cascaded state",
  #    true,
  #    [IsDenseList,IsRecord],
  function(cs,sk)
  local coverchain;
  coverchain := DecodeCoords(sk, HolonomyInts2Sets(sk,cs));
  # extracting the singleton element from the cover chains
  return ListBlist([1..DegreeOfSkeleton(sk)],
                 coverchain[Length(coverchain)])[1];
end;#);

AsHolonomyCoords :=
  #    "raise a flat state into holonomy decomposition",
  #    true,
  #    [IsInt, IsRecord],
  function(k,sk)
  return HolonomySets2Ints(sk,
                 EncodeTileChain(sk,
                         RandomTileChain(sk,k)));
end;#);

IsConstantMap := function(t)
  return RankOfTransformation(t)=1;
end;

# special action for holonomy int coordinates dealing with 0s and constant maps
OnHolonomyCoordinates:= function(coords, ct)
  local dfs, copy, out, len, i, action;
  dfs:=DependencyFunctionsOf(ct);
  len:=Length(coords);
  copy:=EmptyPlist(len);
  out:=EmptyPlist(len);
  for i in [1..len] do
    action := copy^dfs[i];
    if coords[i]=0 then
      if IsTransformation(action) and IsConstantMap(action) then
        out[i] := 1^action;
      else
        out[i] := 0;
      fi;
      copy[i]:=1; #padding with 1: it is precarious but works
    else
      out[i]:=coords[i]^action;
      copy[i]:=coords[i];
    fi;
  od;
  return out;
end;

# creating the permutation action on the tiles, shifted properly to the slot
PermutationOfTiles := function(action, depth, slot, sk)
  local tileaction, shift;
  tileaction := ImageListOfTransformation(
                        TransformationOp(action,
                                TileCoords(sk)[depth][slot],
                                OnFiniteSet));
  #technical bit: shifting the action to the right slot
  shift := Shifts(sk)[depth][slot];
  return Transformation(Concatenation(
                 [1..shift],
                 tileaction + shift));
end;

#looking for a tile that contain the given set on a given level in a given slot
#then creating a constant map resetting to that tile
ConstantMapToATile := function(subtile, depth, slot, sk)
  local pos; # the position of the tile that contains set
  pos := Position(CoordVals(sk)[depth],subtile,Shifts(sk)[depth][slot]);#..Shifts(sk)[depth][slot+1]],
  #just a constant transformation pointing to this tile (encoded as an integer)
   return Transformation(List([1..Size(CoordVals(sk)[depth])],x->pos));
end;

# investigate how s acts on the given states
# returns a list of component actions, one for each level

InstallGlobalFunction(HolonomyComponentActions,function(sk, s, CP)
  local CQ, # tile chains 
        Q, P, # the current set in the chains
        CPs,Ps, # P hit by s
        depth, 
        cas, # encoded component actions
        positionedQ,positionedP; # positioned tiles
  cas := List([1..DepthOfSkeleton(sk)-1],
                  x -> One(HolonomyPermutationResetComponents(sk)[x]));
  #CP := DecodeCoords(sk,coords);
  #Add(CP,BaseSet(sk),1);
  CPs := OnSequenceOfSets(CP,s);
  CQ := DominatingTileChain(sk,CPs);
  positionedQ := PositionedTileChain(sk,CQ);
  positionedP := PositionedTileChain(sk,CP);
  Q := BaseSet(sk);
  P := BaseSet(sk);
  for depth in [1..DepthOfSkeleton(sk)-1] do
    if depth = DepthOfSet(sk,Q) then #TODO positionedQ[depth] <> 0 is faster
      Ps := OnFiniteSet(P,s); #TODO this is already in CPs
      if Ps  = Q then #PERMUTATION
        cas[depth] := PermutationOfTiles(
                              FromRep(sk,P) * s * ToRep(sk,Q),#roundtrip
                              depth,GetSlot(Q,sk),sk);
      else #CONSTANT
        if not IsSubsetBlist(Q,  Ps) then Error("newHEY");fi;
        cas[depth]:=ConstantMapToATile(
                            RepTile(positionedQ[depth],Q,sk),
                            depth,GetSlot(Q,sk),sk);
      fi;
      Q := positionedQ[depth];
    fi;
    if depth = DepthOfSet(sk,P) then
      P := positionedP[depth];
    fi;
  od;
  return cas;
end);

InstallGlobalFunction(HolonomyCascadeSemigroup,
function(ts)
  local sk, S;
  sk := Skeleton(ts);
  S := Semigroup(List(GeneratorsOfSemigroup(ts), t->AsHolonomyCascade(t,sk)));
  SetSkeletonOf(S,sk);
  SetComponentsOfCascadeProduct(S, HolonomyPermutationResetComponents(sk));
  SetIsHolonomyCascadeSemigroup(S,true);
  return S;
end);

#this just enumerates the tile chains, convert to coordinates,
#calls for the component actions, and records if nontrivial
InstallGlobalFunction(AsHolonomyCascade,
function(t,sk)
local i,state,actions,depfuncs,cst, cascade,tilechain,holdom;
  depfuncs := [];
  holdom := [];
  #we go through all tile chains
  if not IsOne(t) then
    for tilechain in AllTileChains(sk) do
      state := HolonomySets2Ints(sk, EncodeTileChain(sk,tilechain));
      Add(holdom, state);
      #get the component actions on the tile chain
      actions := HolonomyComponentActions(sk, t, tilechain);
      #examine whether there is a nontrivial action, then add
      for i in [1..Length(actions)] do
        if not IsOne(actions[i]) then
          if i = 1 then
            AddSet(depfuncs,[[],actions[1]]);
          else
            for cst in
              AllConcreteCoords(ComponentDomains(
                      HolonomyPermutationResetComponents(sk)),
                      state{[1..(i-1)]}) do
              AddSet(depfuncs,[cst,actions[i]]);
            od;
          fi;
        fi;
      od;
    od;
  fi;
  cascade := Cascade(HolonomyPermutationResetComponents(sk),depfuncs);
  SetRestrictedDomain(cascade, holdom);
  return cascade;
end);

InstallGlobalFunction(AsHolonomyTransformation,
function(co,sk)
local l, i;
  l := [];
  for i in ListBlist([1..DegreeOfSkeleton(sk)],
          BaseSet(sk)) do
    l[i]:=AsHolonomyPoint(OnHolonomyCoordinates(AsHolonomyCoords(i,sk),co),sk);
  od;
  return Transformation(l);
end);

# cascade to ts
InstallOtherMethod(HomomorphismTransformationSemigroup,
        "for a holonomy cascade semigroup",
[IsHolonomyCascadeSemigroup],
function(cS)
  local T,sk,f;
  sk := SkeletonOf(cS);
  f := c -> AsHolonomyTransformation(c, sk);
  T:=Semigroup(List(GeneratorsOfSemigroup(cS),f));
  return MappingByFunction(cS,T,f);
end);

# ts to cascade, TODO this is not a set valued morphism yet!!
InstallGlobalFunction(HolonomyRelationalMorphism,
function(S)
  local cS,sk,f;
  cS := HolonomyCascadeSemigroup(S);
  sk := SkeletonOf(cS);
  f := t -> AsHolonomyCascade(t, sk);
  return MappingByFunction(S,cS,f);
end);

#TODO does this work?
#changing the representative
#InstallGlobalFunction(ChangeCoveredSet,
#function(sk, set)
#local skeleton,oldrep, pos, depth,i, tiles;
#  if IsSingleton(set) then
#    Print("#W not changing singleton representative\n");return;
#  fi;
#  skeleton := sk;
#  oldrep := RepresentativeSet(skeleton,set);
#  ChangeRepresentativeSet(skeleton,set);
#  depth := DepthOfSet(skeleton, set);
#  pos := Position(sk.reps[depth], oldrep);
#  sk.reps[depth][pos] := set;
#  tiles := TilesOf(skeleton, set);
#  for i in [1..Length(tiles)] do
#    CoordVals(sk)[depth][Shifts(sk)[depth][pos]+i] := tiles[i];
#  od;
#end);

################################################################################
# REIMPLEMENTED GAP OPERATIONS #################################################

NumOfPointsInSlot := function(sk, level, slot)
  return Shifts(sk)[level][slot+1] - Shifts(sk)[level][slot];
end;
MakeReadOnlyGlobal("NumOfPointsInSlot");

#detailed print of the components
InstallMethod(DisplayString,"for a holonomy decomposition",
        [ IsHolonomyCascadeSemigroup ],
function(HCS)
  local groupnames,level, i,l,groups,sk,str;;
  sk := SkeletonOf(HCS);
  groupnames := [];
  for level in [1..DepthOfSkeleton(sk)-1] do
    l := [];
    groups := GroupComponents(SkeletonOf(HCS))[level];
    for i in [1..Length(groups)]  do
      if IsTrivial(groups[i]) then
        Add(l, String(NumOfPointsInSlot(sk,level,i)));
      elif SgpDecOptionsRec.SMALL_GROUPS then
        Add(l, Concatenation("(",String(NumOfPointsInSlot(sk,level,i)),
                ",", StructureDescription(groups[i]),")"));
      else
        Add(l, Concatenation("(",String(NumOfPointsInSlot(sk,level,i)),
                ",G", String(Order(groups[i])),")"));
      fi;
    od;
    Add(groupnames,l);
  od;
  str := "";
  for i in [1..Length(groupnames)] do
    Append(str, Concatenation(String(i),":"));
    Perform(groupnames[i], function(x) Append(str,Concatenation(" ",x));end);
    Append(str,"\n");
  od;
  return str;
end);

# straightforward implementation for multiplication for sets TODO what is this?
InstallGlobalFunction(SetwiseProduct,
function(S,T)
  local ST,s,t;
  ST := [];
  for s in S do
    for t in T do
      AddSet(ST,s*t);
    od;
  od;
  return ST;
end);

################################################################################
# test functions
TestHolonomyEmulation := function(S)
  local hom,hcs;
  hcs := HolonomyCascadeSemigroup(S);
  hom := HomomorphismTransformationSemigroup(hcs);
  return AsSet(S) = AsSet(Range(hom));
end;
