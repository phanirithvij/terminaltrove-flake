{
  openssl,
  pkg-config,
  rustPlatform,
  fetchFromGitea,
}:
rustPlatform.buildRustPackage rec {
  pname = "joecalsend";
  version = "1.618033988";
  src = fetchFromGitea {
    domain = "git.kittencollective.com";
    owner = "nebkor";
    repo = "joecalsend";
    tag = version;
    hash = "sha256-nzsvVC1e8ENh0bpQwiogGew823NNmSNXN+VZZHfVFIY=";
  };
  cargoHash = "sha256-5V/a6rj08Ucu6S+SBukYQktWLVnnbXeoGan1oYTozHc=";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];
}
