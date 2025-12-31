{
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage {
  name = "swaptop";
  src = fetchFromGitHub {
    owner = "luis-ota";
    repo = "swaptop";
    tag = "v1.0.1";
    hash = "sha256-XMQuQZFY+7IkIJoVCYuDEIRikS1hOH7ql5tj8mzomJQ=";
  };

  buildFeatures = [ "linux" ];

  cargoHash = "sha256-f3Ntcdo71nNHvZ5kfpVhz2l+pazrWog6ODpuDmCSE0g=";
}
