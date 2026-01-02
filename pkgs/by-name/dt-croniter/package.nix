{
  lib,
  python3,
  fetchFromGitHub,
}:
# TODO maybe pin a rev of upstream croniter
# instead of this fork, no commits in fork except a tag
python3.pkgs.croniter.overrideAttrs rec {
  pname = "dt-croniter";
  version = "6.0.1";
  src = fetchFromGitHub {
    owner = "dynatrace-extensions";
    repo = "croniter";
    tag = version;
    hash = "sha256-4KXYdDBIqdu3MzGQKymSDQyw/JAJcTnzMCoG2fUctbs=";
  };
}
