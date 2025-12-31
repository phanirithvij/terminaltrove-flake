{
  pkgs,
  rustPlatform,
  fetchFromGitea,
}:
rustPlatform.buildRustPackage {
  name = "joecalsend";

  src = fetchFromGitea {
    domain = "git.kittencollective.com";
    owner = "nebkor";
    repo = "joecalsend";
    tag = "1.61803398";
    hash = "sha256-7Gl+G4BN3CgF0c/AEhI1OvRhveqGeFNmGRI3XRf6rAo=";
  };

  nativeBuildInputs = with pkgs; [ pkg-config ];

  buildInputs = with pkgs; [ openssl ];

  cargoHash = "sha256-prT1wO3ctnTfMHfICFcihB739lN/QXPH3AamIR6dM9A=";
}
