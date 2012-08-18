#############################################################################
##
## cascadeshell.gd           SgpDec package
##
## Copyright (C) 2008-2012
##
## Attila Egri-Nagy, Chrystopher L. Nehaniv, James D. Mitchell
##
## An empty shell defined by an ordered list of components.
## Used for defining cascaded structures.
##

DeclareOperation("CascadeShell",[IsList,IsList,IsList]);
DeclareGlobalFunction("AllCoords");
DeclareGlobalFunction("CoordValSets");
DeclareGlobalFunction("NameOfDependencyDomain");
DeclareGlobalFunction("SizeOfWreathProduct");
DeclareGlobalFunction("NumberOfDependencyFunctionArguments");

DeclareCategory("IsCascadeShell", IsDenseList);
DeclareProperty("IsCascadedGroupShell", IsCascadeShell);
DeclareRepresentation(
        "IsCascadeShellRep",
        IsComponentObjectRep,
        [ "components", #the building blocks
          "name_of_shell", #a short name constructed from the components
          "state_symbol_functions", #the symbols for printing the the states
          "operation_symbol_functions", #the symbols for printing the operations
          "depdom_names", #the names of dependency domains
          "coordval_sets", #coordinate values (the original statesets of comps)
          "allcoords", #all coordinate tuples (lazy storage)
          "num_of_dependency_entries" #number of distinct dep function arguments
          ]);
CascadeShellType :=
  NewType(NewFamily("CascadeShellFamily",IsCascadeShell),
          IsCascadeShell and IsCascadeShellRep);