gap> START_TEST("Sgpdec package: cascade.tst"); 
gap> LoadPackage("sgpdec", false);;
gap> Read(Concatenation(PackageInfo("sgpdec")[1]!.InstallationPath,
> "/tst/variables.g"));;

# cascade - previously cascade(d) transformation, cascade transform
gap> SemigroupsStartTest();

# Two ways to construct:
# 1. high level, dependency domains + individual dependencise
#    or identity
#    or a random one.
# 2. Low-level CreateCascade for giving the data structure members.

# Cascade
# creating a cascade is done by giving the domains of the dependency
# domains and a list of individual dependencies
gap> c := Cascade([FF,T3],[ [[],Transformation([1,1])],
>               [[1],Transformation([3,3,2])],[[2],Transformation([2,3,2])]]);
<trans cascade with 2 levels with (2, 3) pts, 3 dependencies>
gap> Display(c);
Dependency function of depth 1 with 1 dependencies.
[ ] -> Transformation( [ 1, 1 ] )
Dependency function of depth 2 with 2 dependencies.
[ 1 ] -> Transformation( [ 3, 3, 2 ] )
[ 2 ] -> Transformation( [ 2, 3, 2 ] )

# it is recognized if all components are given and they are groups
# BUT only this case
gap> c := Cascade([Z2,Z3], [ [[],(1,2)], [[1],(1,2,3)] ]);
<perm cascade with 2 levels with (2, 3) pts, 2 dependencies>
gap> Display(c);
Dependency function of depth 1 with 1 dependencies.
[ ] -> (1,2)
Dependency function of depth 2 with 1 dependencies.
[ 1 ] -> (1,2,3)
gap> IsPermCascade(c);
true

# so the usual invertible multiplicative functions work
gap> One(c);
<perm cascade with 2 levels with (2, 3) pts, 0 dependencies>
gap> ic := Inverse(c);
<perm cascade with 2 levels with (2, 3) pts, 2 dependencies>
gap> Display(ic);
Dependency function of depth 1 with 1 dependencies.
[ ] -> (1,2)
Dependency function of depth 2 with 1 dependencies.
[ 2 ] -> (1,3,2)
gap> Order(c);
6

# it is also possible to give only component domains, in that case
gap> Cascade([[1..2],[1..3]],[]);
<trans cascade with 2 levels with (2, 3) pts, 0 dependencies>

# identity cascade
gap> IdentityCascade([T3,Z2]);
<trans cascade with 2 levels with (3, 2) pts, 0 dependencies>

#from here on just testing (no descriptions)...
#formerly mul.g....

#becks
gap> semis := [
> [Transformation([1,2,3,1,1,1]), Transformation([4,4,4,5,4,6]),
> Transformation([4,4,4,5,6,4]), Transformation([4,4,4,4,5,5]),
> Transformation([4,4,4,1,2,3]), Transformation([2,3,1,4,4,4])]];;

#heybug
gap> Add(semis, [Transformation( [ 2,2,4,4,6,6,8,8 ] ),
> Transformation( [ 1,2,3,5,5,6,7,5 ] ),
> Transformation( [ 1,2,3,4,3,4,3,4 ] ) ]);;

#microbug
gap> Add(semis, [Transformation( [ 1,2,1 ] ),Transformation( [ 3,3,1 ] )]);;

#alifex
gap> Add(semis, [Transformation([2,2,3,3,3]),Transformation([3,3,3,5,4])]);;
gap> semis:=List(semis, Semigroup);
[ <transformation semigroup on 6 pts with 6 generators>, 
  <transformation semigroup on 8 pts with 3 generators>, 
  <transformation semigroup on 3 pts with 2 generators>, 
  <transformation semigroup on 5 pts with 2 generators> ]

#test the multiplication
gap> comps:=[semis[1], semis[2], SymmetricGroup(3)];;
gap> for i in [1..333] do
>   rc1 := RandomCascade(comps, 13);
>   rc2 := RandomCascade(comps, 11);
>   if AsTransformation(rc1*rc2)<>AsTransformation(rc1) * AsTransformation(rc2)
>     then Print("multiplication of cascades isn't working...1\n");
>   fi;
>   if AsCascade(AsTransformation(rc2) * AsTransformation(rc1), comps)<>
>    rc2*rc1 then  
>     Print("multiplication of cascades isn't working...2\n");
>   fi;
> od;

#
gap> comps:=[semis[3], semis[2], semis[4]];;
gap> for i in [1..333] do
>   rc1 := RandomCascade(comps, 13);
>   rc2 := RandomCascade(comps, 11);
>   if AsTransformation(rc1*rc2)<>AsTransformation(rc1) * AsTransformation(rc2)
>     then Print("multiplication of cascades isn't working...3\n");
>   fi;
>   if AsCascade(AsTransformation(rc2) * AsTransformation(rc1), comps)<>
>    rc2*rc1 then  
>     Print("multiplication of cascades isn't working...4\n");
>   fi;
> od;

#
gap> c:=
> Cascade( [ [ 1 .. 3 ], [ 1 .. 8 ], [ 1 .. 5 ] ], 
> [ [ [  ], Transformation( [ 3, 3, 3 ] ) ], 
>   [ [ 1 ], Transformation( [ 2, 2, 4, 6, 6, 6, 8, 6 ] ) ], 
>   [ [ 2 ], Transformation( [ 2, 2, 6, 6, 6, 6, 6, 6 ] ) ], 
>   [ [ 3 ], Transformation( [ 2, 2, 4, 4, 4, 4, 4, 4 ] ) ], 
>   [ [ 1, 1 ], Transformation( [ 3, 3, 3, 3, 3 ] ) ], 
>   [ [ 1, 2 ], Transformation( [ 3, 3, 3, 3, 3 ] ) ], 
>   [ [ 1, 3 ], Transformation( [ 2, 2, 3, 3, 3 ] ) ], 
>   [ [ 1, 4 ], Transformation( [ 2, 2, 3, 3, 3 ] ) ], 
>   [ [ 1, 5 ], Transformation( [ 3, 3, 3, 3, 3 ] ) ], 
>   [ [ 1, 6 ], Transformation( [ 3, 3, 3, 3, 3 ] ) ], 
>   [ [ 1, 7 ], Transformation( [ 3, 3, 3, 3, 3 ] ) ], 
>   [ [ 1, 8 ], Transformation( [ 3, 3, 3, 3, 3 ] ) ], 
>   [ [ 2, 1 ], Transformation( [ 3, 3, 3 ] ) ], 
>   [ [ 2, 2 ], Transformation( [ 2, 2, 3, 3, 3 ] ) ], 
>   [ [ 2, 3 ], Transformation( [ 3, 3, 3, 3, 3 ] ) ], 
>   [ [ 2, 4 ], Transformation( [ 3, 3, 3, 3, 3 ] ) ], 
>   [ [ 2, 5 ], Transformation( [ 3, 3, 3, 5, 4 ] ) ], 
>   [ [ 2, 6 ], Transformation( [ 3, 3, 3 ] ) ], 
>   [ [ 2, 7 ], Transformation( [ 3, 3, 3, 5, 4 ] ) ], 
>   [ [ 2, 8 ], Transformation( [ 3, 3, 3, 3, 3 ] ) ], 
>   [ [ 3, 1 ], Transformation( [ 3, 3, 3, 3, 3 ] ) ], 
>   [ [ 3, 2 ], Transformation( [ 2, 2, 3, 3, 3 ] ) ], 
>   [ [ 3, 3 ], Transformation( [ 3, 3, 3, 3, 3 ] ) ], 
>   [ [ 3, 4 ], Transformation( [ 3, 3, 3, 3, 3 ] ) ], 
>   [ [ 3, 5 ], Transformation( [ 3, 3, 3, 3, 3 ] ) ], 
>   [ [ 3, 6 ], Transformation( [ 3, 3, 3, 3, 3 ] ) ], 
>   [ [ 3, 7 ], Transformation( [ 3, 3, 3, 3, 3 ] ) ], 
>   [ [ 3, 8 ], Transformation( [ 3, 3, 3, 3, 3 ] ) ] ] );
<trans cascade with 3 levels with (3, 8, 5) pts, 28 dependencies>
gap> d:=
> Cascade( [ [ 1 .. 3 ], [ 1 .. 8 ], [ 1 .. 5 ] ], 
> [ [ [  ], Transformation( [ 1, 1, 1 ] ) ], 
>   [ [ 3 ], Transformation( [ 2, 2, 5, 5, 6, 6, 5, 5 ] ) ], 
>   [ [ 1, 1 ], Transformation( [ 3, 3, 3, 3, 3 ] ) ], 
>   [ [ 1, 2 ], Transformation( [ 2, 2, 3, 3, 3 ] ) ], 
>   [ [ 1, 3 ], Transformation( [ 3, 3, 3, 3, 3 ] ) ], 
>   [ [ 1, 5 ], Transformation( [ 2, 2, 3, 3, 3 ] ) ], 
>   [ [ 1, 6 ], Transformation( [ 3, 3, 3, 5, 4 ] ) ], 
>   [ [ 1, 7 ], Transformation( [ 2, 2, 3, 3, 3 ] ) ], 
>   [ [ 1, 8 ], Transformation( [ 2, 2, 3, 3, 3 ] ) ], 
>   [ [ 2, 1 ], Transformation( [ 3, 3, 3, 5, 4 ] ) ], 
>   [ [ 2, 2 ], Transformation( [ 3, 3, 3, 3, 3 ] ) ], 
>   [ [ 2, 4 ], Transformation( [ 3, 3, 3, 3, 3 ] ) ], 
>   [ [ 2, 5 ], Transformation( [ 3, 3, 3, 5, 4 ] ) ], 
>   [ [ 2, 6 ], Transformation( [ 3, 3, 3, 3, 3 ] ) ], 
>   [ [ 2, 7 ], Transformation( [ 2, 2, 3, 3, 3 ] ) ], 
>   [ [ 2, 8 ], Transformation( [ 2, 2, 3, 3, 3 ] ) ], 
>   [ [ 3, 1 ], Transformation( [ 3, 3, 3, 3, 3 ] ) ], 
>   [ [ 3, 6 ], Transformation( [ 3, 3, 3, 3, 3 ] ) ], 
>   [ [ 3, 7 ], Transformation( [ 3, 3, 3, 3, 3 ] ) ], 
>   [ [ 3, 8 ], Transformation( [ 3, 3, 3, 3, 3 ] ) ] ] );
<trans cascade with 3 levels with (3, 8, 5) pts, 20 dependencies>
gap> c*d;
<trans cascade with 3 levels with (3, 8, 5) pts, 28 dependencies>
gap> PrintString(c*d);
"Cascade( [ [ 1 .. 3 ], [ 1 .. 8 ], [ 1 .. 5 ] ], [ [ [ ], Transformation( [ 1\
, 1, 1 ] ) ], [ [ 1 ], Transformation( [ 2, 2, 5, 6, 6, 6, 5, 6 ] ) ], [ [ 2 ]\
, Transformation( [ 2, 2, 6, 6, 6, 6, 6, 6 ] ) ], [ [ 3 ], Transformation( [ 2\
, 2, 5, 5, 5, 5, 5, 5 ] ) ], [ [ 1, 1 ], Transformation( [ 3, 3, 3, 3, 3 ] ) ]\
, [ [ 1, 2 ], Transformation( [ 3, 3, 3, 3, 3 ] ) ], [ [ 1, 3 ], Transformatio\
n( [ 2, 2, 3, 3, 3 ] ) ], [ [ 1, 4 ], Transformation( [ 3, 3, 3, 3, 3 ] ) ], [\
 [ 1, 5 ], Transformation( [ 3, 3, 3, 3, 3 ] ) ], [ [ 1, 6 ], Transformation( \
[ 3, 3, 3, 3, 3 ] ) ], [ [ 1, 7 ], Transformation( [ 3, 3, 3, 3, 3 ] ) ], [ [ \
1, 8 ], Transformation( [ 3, 3, 3, 3, 3 ] ) ], [ [ 2, 1 ], Transformation( [ 3\
, 3, 3 ] ) ], [ [ 2, 2 ], Transformation( [ 2, 2, 3, 3, 3 ] ) ], [ [ 2, 3 ], T\
ransformation( [ 3, 3, 3, 3, 3 ] ) ], [ [ 2, 4 ], Transformation( [ 3, 3, 3, 3\
, 3 ] ) ], [ [ 2, 5 ], Transformation( [ 3, 3, 3, 3, 3 ] ) ], [ [ 2, 6 ], Tran\
sformation( [ 3, 3, 3, 3, 3 ] ) ], [ [ 2, 7 ], Transformation( [ 3, 3, 3, 3, 3\
 ] ) ], [ [ 2, 8 ], Transformation( [ 3, 3, 3, 3, 3 ] ) ], [ [ 3, 1 ], Transfo\
rmation( [ 3, 3, 3, 3, 3 ] ) ], [ [ 3, 2 ], Transformation( [ 2, 2, 3, 3, 3 ] \
) ], [ [ 3, 3 ], Transformation( [ 3, 3, 3, 3, 3 ] ) ], [ [ 3, 4 ], Transforma\
tion( [ 3, 3, 3, 3, 3 ] ) ], [ [ 3, 5 ], Transformation( [ 3, 3, 3, 3, 3 ] ) ]\
, [ [ 3, 6 ], Transformation( [ 3, 3, 3, 3, 3 ] ) ], [ [ 3, 7 ], Transformatio\
n( [ 3, 3, 3, 3, 3 ] ) ], [ [ 3, 8 ], Transformation( [ 3, 3, 3, 3, 3 ] ) ] ] \
)"

#
gap> SemigroupsStopTest();
gap> STOP_TEST( "Sgpdec package: cascade.tst", 10000);   
