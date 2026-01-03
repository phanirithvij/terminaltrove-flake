{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:

buildNpmPackage (finalAttrs: {
  pname = "git-split-diffs";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "banga";
    repo = "git-split-diffs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3kprATuDvtXSocoVx/Fvd00z0d4nhZZZ3UqBEFmctYE=";
  };

  npmDepsHash = "sha256-mQ+JhWnBNMvHBL9T1nzIhsmMpQOTzoce5g3n3C1SrJE=";

  meta = {
    changelog = "https://github.com/banga/git-split-diffs/releases/tag/v${finalAttrs.version}";
    description = "Syntax highlighted side-by-side diffs in your terminal";
    homepage = "https://github.com/banga/git-split-diffs";
    license = lib.licenses.mit;
    mainProgram = "git-split-diffs";
    maintainers = with lib.maintainers; [ phanirithvij ];
    platforms = lib.platforms.all;
  };
})
