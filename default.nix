# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs
, uv2nix
, pyproject-nix
, pyproject-build-systems
}:

{
  loggo = pkgs.callPackage ./pkgs/loggo { };
  awsesh = pkgs.callPackage ./pkgs/awsesh { };
  cloctui = pkgs.callPackage ./pkgs/cloctui {
    inherit uv2nix pyproject-nix pyproject-build-systems;
  };
  comchan = pkgs.callPackage ./pkgs/comchan { };
  qmassa = pkgs.callPackage ./pkgs/qmassa { };
  swaptop = pkgs.callPackage ./pkgs/swaptop { };
}
