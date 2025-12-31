{
  pkgs,
  uv2nix,
  pyproject-nix,
  pyproject-build-systems,
  fetchFromGitHub,
}:
let
  src = fetchFromGitHub {
    owner = "edward-jazzhands";
    repo = "cloctui";
    rev = "355724bbe76704464af2c0af6c1dded15d211f8a"; # no tags
    hash = "sha256-eGV3nyJSyxIVbb641wsJx3Jxo63LhIBDUUoMx2lMsco=";
  };

  workspace = uv2nix.lib.workspace.loadWorkspace {
    workspaceRoot = src;
  };

  overlay = workspace.mkPyprojectOverlay {
    sourcePreference = "wheel";
  };

  pythonSet =
    (pkgs.callPackage pyproject-nix.build.packages {
      python = pkgs.python312;
    }).overrideScope
      (
        pkgs.lib.composeManyExtensions [
          pyproject-build-systems.overlays.default
          overlay
        ]
      );

  cloctui_venv = pythonSet.mkVirtualEnv "cloctui" workspace.deps.default;
in
pkgs.writeShellApplication {
  name = "cloctui";
  runtimeInputs = [ cloctui_venv ];
  text = ''
    exec cloctui "$@"
  '';
}
