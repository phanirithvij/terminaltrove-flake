{
  lib,
  stdenv,
  pkg-config,
  systemdLibs,

  rustPlatform,
  fetchFromGitHub,
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
}
