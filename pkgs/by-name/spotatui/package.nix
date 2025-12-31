{
  lib,
  rustPlatform,
  fetchFromGitHub,

  patchelf,
  pkg-config,
  llvmPackages,

  dbus,
  openssl,
  alsa-lib,
  pipewire,

  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "spotatui";
  version = "0.34.6";

  src = fetchFromGitHub {
    owner = "largemodgames";
    repo = "spotatui";
    rev = "v${version}";
    hash = "sha256-Lrv4XQakWQu3E2zcIT0WXGVM1GT/XvLi6SGKnJCoD2A=";
  };

  cargoHash = "sha256-JAPytv+PLixO+vjrBRhzYXdfZMfA3odMqLwg+wHj7/8=";

  nativeBuildInputs = [
    pkg-config
    patchelf
    llvmPackages.clang
    llvmPackages.libclang
  ];

  buildInputs = [
    openssl
    alsa-lib
    dbus
    pipewire
  ];

  postFixup = ''
    patchelf \
      --set-rpath "${
        lib.makeLibraryPath [
          openssl
          alsa-lib
          dbus
          pipewire
        ]
      }" \
      $out/bin/spotatui
  '';

  doInstallCheck = true;
  versionCheckProgramArg = "--version";
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal UI Spotify client";
    homepage = "https://github.com/largemodgames/spotatui";
    license = lib.licenses.mit;
    mainProgram = "spotatui";
    platforms = lib.platforms.linux;
  };
}
