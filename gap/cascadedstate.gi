#############################################################################
##
## cascadedstate.gi           SgpDec package
##
## Copyright (C) 2008-2012
##
## Attila Egri-Nagy, Chrystopher L. Nehaniv, James D. Mitchell
##
## Dealing with cascaded states.
##

# CONSTRUCTOR
# The actual cascaded states are reused. So the constructor just checks whether
# it is a valid list of coordinate values.
#InstallGlobalFunction(CascadedState,
#function(csh,coords)
#local i;
  #if the length is bigger then we fail (overspecialized!)
#  if Length(coords) > Length(csh)  then
#    Print("Overspecialized! Too many levels!\n");
#    return fail;
#  fi;

  # checking whether the values are in range #TODO!! possibly a noncheck version
  # for speedup
#  for i in [1..Length(coords)] do
#    if coords[i] > Length(StateSets(csh)[i]) or coords[i]<0 then
#      Print(i,"th coordinate value out of range!\n");
#      return fail;
#    fi;
#  od;

  # just a normal state not an abstract one
#  if Length(coords) = Length(csh) then
#    return Objectify(CascadedStateType,rec(coords:=coords,csh:=csh));
#  else
#    return Objectify(AbstractCascadedStateType,rec(coords:=coords,csh:=csh));
#  fi;
#end);

####LOWLEVEL YEAST#####################################
# Collapsing for states - just returning the index as the states are stored in
# order.
InstallOtherMethod(Flatten, "for a cascaded state",
[IsCascadeShell,IsDenseList],
function(csh,  coords )
  return PositionCanonical(States(csh),coords);
end);

#TODO!! Get this back!!
#InstallOtherMethod(Flatten, "for an abstract cascaded state",
#[IsAbstractCascadedState],
#function( acs )
#local l;
#  l := [];
#  Perform(AllConcreteCascadedStates(acs), function(x) AddSet(l,Flatten(x));end);
#  return  l;
#end);


# Building cascaded states - since the states are stored in a list, the flat
# state is just the index
InstallOtherMethod(Raise, "for cascade shell and integer",
[IsDenseList, IsPosInt],
function( csh, state ) return States(csh)[state]; end);

#for abstract positions we put 1 (a surely valid coordinate value) replacing 0
InstallGlobalFunction(Concretize,
function(csh, abstract_state)
local l;
  #csh := CascadeShellOf(abstract_state);
  l := List(abstract_state,
            function(x) if x>0 then return x; else return 1;fi;end);
  #then append the list with 1s
  Append(l, ListWithIdenticalEntries(Length(csh) - Size(abstract_state), 1));
  return l;#CascadedState(csh, l);
end);

InstallGlobalFunction(AllConcreteCascadedStates,
function(abstract_state)
local csh, concretestates;
  csh := CascadeShellOf(abstract_state);
  concretestates :=  EnumeratorOfCartesianProduct(
                             List([1..Size(csh)],
    function(x)
      if IsBound(abstract_state[x]) and abstract_state[x]>0 then
        return [abstract_state[x]];
      else
        return StateSets(csh)[x];
      fi;
    end));
  return concretestates;#List(concretestates, x -> CascadedState(csh,x));
end);

###############################################################
############ OLD METHODS ######################################
###############################################################

# equality - just check the equality of the underlying lists, thus it works for
# abstract states as well
#InstallOtherMethod(\=, "deciding equality of cascaded states", IsIdenticalObj,
#[IsAbstractCascadedState, IsAbstractCascadedState],
#function(p,q) return p!.coords = q!.coords; end);

#############################################################################
#InstallMethod( ViewObj, "for an abstract cascaded state",
#[IsAbstractCascadedState],
#function( cs )
#  local i, csh;

#  csh := CascadeShellOf(cs);
#  Print("C(");
#  for i in [1..Length(csh)] do
#    if i <= Length(cs) and cs[i] > 0 then
#      Print(csh!.state_symbol_functions[i](cs[i]));
#    else
#      Print("*");
#    fi;
#    if i < Length(csh) then
#      Print(",");
#    fi;
#  od;
#  Print(")");
#  return;
#end);

# for accessing the list elements
#InstallOtherMethod( \[\], "for an abstract cascaded state and pos int",
#[ IsAbstractCascadedState, IsPosInt ],
#function( cs, pos ) return cs!.coords[pos]; end);

#################################################################
#InstallMethod(Length,"for an abstract cascaded state",
#[IsAbstractCascadedState],
#function(cs) return Length(cs!.coords); end);

#################ACCESS FUNCTIONS######################
#InstallMethod(CascadeShellOf, "for an abstract cascaded state",
#[IsAbstractCascadedState],
#function(cs) return cs!.csh; end);