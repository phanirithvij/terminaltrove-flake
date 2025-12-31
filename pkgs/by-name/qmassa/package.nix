{
  pkgs,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage {
  name = "qmassa";
  src = fetchFromGitHub {
    owner = "ulissesf";
    repo = "qmassa";
    tag = "v1.0.1";
    hash = "sha256-EKvK/+0xs0yAwp0TiQVcGJjc9TfShQIHSxcDPkZyr4I=";
  };

  nativeBuildInputs = with pkgs; [
    pkg-config
  ];

  buildInputs = with pkgs; [
    systemd
  ];

  cargoHash = "sha256-L5OzshWGPw8OIVE4GCW99Qib8udbSNVsl+IYWnG0NAU=";
}
