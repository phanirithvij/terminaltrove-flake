{
  lib,
  systemd,
  pkg-config,

  rustPlatform,
  fetchFromGitHub,

  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "qmassa";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "ulissesf";
    repo = "qmassa";
    tag = "v${version}";
    hash = "sha256-85kN/tGBpMvjnshmzBYSy8O2EQf8IlqrXLme2oWJAXo=";
  };

  cargoHash = "sha256-q6ajcwuJ6TeuYNYexB3mUMHBD/74pbG3thfvZ0z7EPc=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ systemd ];

  doInstallCheck = true;
  versionCheckProgramArg = "--version";
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/ulissesf/qmassa/blob/${src.tag}/CHANGELOG.md";
    description = "Rust terminal-based tool for displaying GPUs usage stats on Linux";
    homepage = "https://github.com/ulissesf/qmassa";
    license = lib.licenses.asl20;
    mainProgram = "qmassa";
    maintainers = with lib.maintainers; [
      ipsavitsky
      phanirithvij
    ];
  };
}
