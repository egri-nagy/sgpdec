MultiReplace := function(str, pairs)
  local pair;
  for pair in pairs do
    str := ReplacedString(str,pair[1],pair[2]);
  od;
  return str;
end;

DepthVector := function(str)
  local openers,closers,last,depth, i, depthvect;
  openers := "[(";
  closers := ")]";
  depth := 0;
  depthvect := EmptyPlist(Size(str));
  for i in [1..Size(str)] do
    if str[i] in openers then
      depth := depth + 1;
    elif str[i] in closers then
      depth := depth - 1;
    fi;
    depthvect[i]:= depth;
  od;
  return depthvect;
end;

SplitStringAtPositions := function(str, poss)
  local pieces, last,i;
  last := 0;
  pieces := [];
  for i in [1..Size(poss)] do
    Add(pieces, str{[last+1..poss[i]]});
    last := poss[i];
  od;
  return pieces;
end;

# finding the components in the string
LinNotComps := function(str)
  SplitStringAtPositions(str, Positions(DepthVector(str),0));
end;

# finding the components in the string
CommaComps := function(str)
  local cuts;
  cuts := Intersection(Positions(DepthVector(str),0),
                  Positions(str,','));
  Add(cuts, Size(str));
  #post process: removing dangling commas
  return List(SplitStringAtPositions(str, cuts),
              function(s) if s[Size(s)]=',' then return s{[1..Size(s)-1]};
                          else return s; fi;end);
end;

#just remove outer parentheses
CutParentheses := function(str) return str{[2..Size(str)-1]}; end;

#this gets the last image
GetImgVal := function(str)
local s, poss, lastpos;
  if Int(str) <> fail then return str;
  else
    s := CutParentheses(str);
    Display(s);
    poss := Positions(str, ';');
    lastpos := poss[Size(poss)];
    return s{[lastpos..Size(s)]};
  fi;
end;

#recursively fill the list maps [point, image] tuples
AllMapsFromLinNot := function(str)
  local maps,l,i;
  maps := [];
  if str[1] = '(' then
    # permutation
    l := List(CommaComps(CutParentheses(str)), s->Int(GetImgVal(s)));
    Add(l, l[1]); #closing the circle
    for i in [1..Size(l)-1] do
      Add(maps, [l[i],l[i+1]]);
    od;
  else
  fi;
  return maps;
end;
