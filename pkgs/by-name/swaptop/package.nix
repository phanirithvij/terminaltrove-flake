{
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "swaptop";
  version = "1.0.5";
  src = fetchFromGitHub {
    owner = "luis-ota";
    repo = "swaptop";
    tag = "v${version}";
    hash = "sha256-7AdV+VGrOOHYeBXgph+rVDcFSge0CRGSzDX7pR/csFY=";
  };
  cargoHash = "sha256-niOpQ6AfEHKsIUoMzS9qUvfrZHmN3xp1+cwUhafhWd8=";
}
