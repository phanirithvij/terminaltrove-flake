## WHAT

Bring all of tools mentioned in terminaltrove.com to nixpkgs (based on some
threshold) or into this repo.

Threshold could be spread on repology, github stars.

### Packaging Checklist

- [ ] package tests, go, rust checkPhase.
- [ ] NixosTests if upstream cares about them
  - e2e requiring some docker/services setup
  - eg. pdfding e2e, kaskade e2e
- [ ] versionCheckHook or fallback to testers.testVersion
  - prefer versionCheckHook (better to have broken builds and fix them)
- [ ] nix-update-script
- [ ] manpages and shell completions
- [ ] meta
  - [ ] changelog, description, homepage, downloadPage, maintainers
  - [ ] mainProgram
  - [ ] license
  - [ ] platforms

### TODOS

- [ ] ngipkgs like top-level interface
- [ ] nixosTests overlay?
- [ ] python modules overlay?
- [ ] Branch off nixpkgs master?
- [ ] GHA + cachix + oranc
  - [ ] nur ci.nix (gha) or buildbot-nix (using gha?)
- [ ] nix-vm-tests?
- [ ] upstream pkgs as per the above criteria
- [ ] Dashboard
  - General, try adopting nix-forge (for this flake), nix geospacial team dashboards (for nixpkgs)
