# Copied code from ngipkgs by-name/default.nix licensed MIT Copyright (c) 2023 NGIpkgs contributors
{ callPackage, lib }:
let
  inherit (builtins)
    elem
    pathExists
    readDir
    ;

  inherit (lib.attrsets)
    concatMapAttrs
    mapAttrs
    ;

  baseDirectory = ./.;

  packageDirectories =
    let
      names =
        name: type:
        if type == "directory" then
          { ${name} = baseDirectory + "/${name}"; }
        # nothing else should be kept in this directory reserved for derivations
        else
          assert elem name allowedFiles;
          { };
      allowedFiles = [
        "README.md"
        "default.nix"
      ];
    in
    concatMapAttrs names (readDir baseDirectory);

  self' = mapAttrs (
    _: directory:
    if pathExists (directory + "/package.nix") then
      callPackage (directory + "/package.nix") { }
    else
      throw "No package.nix found in ${directory}"
  ) packageDirectories;
in
self'
