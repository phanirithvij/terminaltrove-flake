{
  pkgs,
  rustPlatform,
  fetchFromGitHub
}:
rustPlatform.buildRustPackage {
  name = "comchan";

  src = fetchFromGitHub {
    owner = "Vaishnav-Sabari-Girish";
    repo = "ComChan";
    tag = "v0.2.3";
    hash = "sha256-39ErzMqG3pKvSz7SEgFmUHm4wFrFN6XtYbM2O+Xo1m0=";
  };

  nativeBuildInputs = with pkgs; [ pkg-config ];

  cargoHash = "sha256-BE7/fIZkqNIIpxxnCkb3j2bvMR9sTphCVX5SwBW+mek=";
}
