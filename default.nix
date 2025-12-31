# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

let
  flake-inputs = import (fetchTarball {
    url = "https://github.com/fricklerhandwerk/flake-inputs/tarball/4.1.0";
    sha256 = "1j57avx2mqjnhrsgq3xl7ih8v7bdhz1kj3min6364f486ys048bm";
  });
  inherit (flake-inputs) import-flake;
in
{
  flake ? import-flake { src = ./.; },
  sources ? flake.inputs,
  nixpkgs ? sources.nixpkgs,
  config ? { }, # allows --arg config from cli
  overlays ? [ ],
  system ? builtins.currentSystem,
  pkgs ? import nixpkgs {
    inherit
      config
      overlays
      system
      ;
  },
  lib ? import "${nixpkgs}/lib",
  uv2nix ? sources.uv2nix,
  pyproject-nix ? sources.pyproject-nix,
  pyproject-build-systems ? sources.pyproject-build-systems,
}:
let
  # restrict scope to by-name
  callPackage = pkgs.newScope (
    self'
    // {
      inherit callPackage;
      inherit uv2nix pyproject-nix pyproject-build-systems;
    }
  );

  pkgsByName = import ./pkgs/by-name { inherit callPackage lib; };
  self' = pkgsByName;

  self = self' // { };
in
self
