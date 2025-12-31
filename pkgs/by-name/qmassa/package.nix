{
  systemd,
  pkg-config,

  rustPlatform,
  fetchFromGitHub,
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
}
