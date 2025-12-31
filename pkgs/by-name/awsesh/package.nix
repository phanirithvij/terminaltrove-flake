{ buildGoModule, fetchFromGitHub }:

buildGoModule (finalAttrs: {
  pname = "awsesh";
  version = "0.1.11";
  src = fetchFromGitHub {
    owner = "elva-labs";
    repo = "awsesh";
    tag = "v.${finalAttrs.version}";
    hash = "sha256-14f6Wa+UZaXNq45D+bLeb4M5gui1BBdSgycI+bYc4MI=";
  };
  vendorHash = "sha256-hGwGvE9Y0awezAijHMt5heBERcV92olugCaMzzvDvKc=";
})
