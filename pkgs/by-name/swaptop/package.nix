{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
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

  # has no cli commands like --help --version

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/luis-ota/swaptop/releases/tag/${src.tag}";
    description = "Swap usage monitor written in rust";
    homepage = "https://github.com/luis-ota/swaptop";
    license = lib.licenses.mit;
    mainProgram = "swaptop";
    maintainers = with lib.maintainers; [
      ipsavitsky
      phanirithvij
    ];
    platforms = lib.platforms.linux;
  };
}
