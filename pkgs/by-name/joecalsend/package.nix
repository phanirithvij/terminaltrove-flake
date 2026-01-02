{
  lib,
  rustPlatform,
  fetchFromGitea,

  openssl,
  pkg-config,

  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "joecalsend";
  # see https://git.kittencollective.com/nebkor/joecalsend/src/branch/main/VERSIONING.md
  version = "1.6.18033988";

  src = fetchFromGitea {
    domain = "git.kittencollective.com";
    owner = "nebkor";
    repo = "joecalsend";
    tag =
      let
        # Remove middle dot from version string (1.6.18033988 -> 1.618033988)
        # because GitHub release tags use the condensed format
        parts = builtins.splitVersion version;
        ver = "${builtins.elemAt parts 0}.${builtins.elemAt parts 1}${builtins.elemAt parts 2}";
      in
      ver;
    hash = "sha256-nzsvVC1e8ENh0bpQwiogGew823NNmSNXN+VZZHfVFIY=";
  };

  cargoHash = "sha256-5V/a6rj08Ucu6S+SBukYQktWLVnnbXeoGan1oYTozHc=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  postInstall = ''
    ln -s $out/bin/jocalsend $out/bin/joecalsend
  '';

  doInstallCheck = true;
  versionCheckProgramArg = "--version";
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://git.kittencollective.com/nebkor/joecalsend/releases/tag/${version}";
    description = "Rust terminal client for Localsend";
    homepage = "https://git.kittencollective.com/nebkor/joecalsend";
    # https://git.kittencollective.com/nebkor/joecalsend/src/branch/main/LICENSE.md
    license = lib.licenses.unfree; # anti-llm and another non-osi approved license
    mainProgram = "jocalsend";
    maintainers = with lib.maintainers; [
      ipsavitsky
      phanirithvij
    ];
  };
}
