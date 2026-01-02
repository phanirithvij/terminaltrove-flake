{
  lib,
  stdenv,
  pkg-config,
  systemdLibs,

  rustPlatform,
  fetchFromGitHub,

  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "comchan";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "Vaishnav-Sabari-Girish";
    repo = "ComChan";
    tag = "v${version}";
    hash = "sha256-v8kKRZyC9aPLmoZvXonzL2Uy3Y3pB7OL3VXtO/aogc4=";
  };

  cargoHash = "sha256-4AgC+rMjzyN3sIkwf6rsEKWc5AvZVtijG6MJH1A3Sbg=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    systemdLibs # libudev-sys
  ];

  doInstallCheck = true;
  versionCheckProgramArg = "--version";
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Minimal Serial Monitor written in Rust";
    homepage = "https://vaishnav.world/ComChan/";
    license = lib.licenses.mit;
    mainProgram = "comchan";
    maintainers = with lib.maintainers; [
      ipsavitsky
      phanirithvij
    ];
  };
}
