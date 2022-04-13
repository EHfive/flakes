rec {
  attrsToList = attrSet:
    builtins.foldl'
      (sum: name:
        sum ++ [{ inherit name; value = attrSet.${name}; }]
      )
      [ ]
      (builtins.attrNames attrSet)
  ;

  filterAttrSet = f: attrSet:
    builtins.foldl'
      (sum: name:
        let value = attrSet.${name}; in
        if f value then
          sum // { ${name} = value; }
        else sum
      )
      { }
      (builtins.attrNames attrSet)
  ;

  filterNonNull = filterAttrSet (f: f != null);

  checkPlatform = system: pkg:
    !(pkg ? meta && pkg.meta ? platforms)
    || (builtins.elem system pkg.meta.platforms)
  ;
}
