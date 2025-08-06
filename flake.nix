{
  description = "A NUR repository for programs featured on terminaltrove";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.uv2nix.follows = "uv2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, flake-utils, pyproject-nix, uv2nix, pyproject-build-systems }: flake-utils.lib.eachDefaultSystem (
    system:
    let
      pkgs = import nixpkgs { inherit system; };
    in
    {
      packages = import ./default.nix { inherit pkgs pyproject-nix uv2nix pyproject-build-systems; };

      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          nil
        ];
      };
    }
  );
}
