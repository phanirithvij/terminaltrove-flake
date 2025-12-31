{ buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "loggo";
  version = "v0.3.21";
  src = fetchFromGitHub {
    owner = "aurc";
    repo = "loggo";
    tag = version;
    hash = "sha256-j+vrfEmgMRfR0iE/67z+s2icRR57igEP3UaVduVaYK0=";
  };
  vendorHash = "sha256-lUGDWsU/5g6TcC4WgEh/RCshgkD/XtXzC8O0VoNa6fs=";
  doCheck = false;
}
