{ buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "awsesh";
  version = "v.0.1.4";
  src = fetchFromGitHub {
    owner = "elva-labs";
    repo = "awsesh";
    tag = version;
    hash = "sha256-IJd6l+04ie8jiBgmpbWr/txKJDAzetXQqyb5naZSGBg=";
  };
  vendorHash = "sha256-hGwGvE9Y0awezAijHMt5heBERcV92olugCaMzzvDvKc=";
}
