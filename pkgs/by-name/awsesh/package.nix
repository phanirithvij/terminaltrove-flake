{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

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

  ldflags = [
    "-s"
    "-X main.Version=${finalAttrs.version}"
  ];

  doInstallCheck = true;
  versionCheckProgramArg = "--version";
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/elva-labs/awsesh/releases/tag/${finalAttrs.src.tag}";
    description = "TUI for AWS SSO session management";
    homepage = "https://github.com/elva-labs/awsesh";
    license = lib.licenses.mit;
    mainProgram = "awsesh";
    maintainers = with lib.maintianers; [
      ipsavitsky
      phanirithvij
    ];
  };
})
