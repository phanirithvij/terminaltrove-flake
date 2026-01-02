{
  lib,
  buildGoModule,
  fetchFromGitHub,

  versionCheckHook,
  writableTmpDirAsHomeHook,

  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "loggo";
  version = "0.3.21";

  src = fetchFromGitHub {
    owner = "aurc";
    repo = "loggo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j+vrfEmgMRfR0iE/67z+s2icRR57igEP3UaVduVaYK0=";
  };

  vendorHash = "sha256-lUGDWsU/5g6TcC4WgEh/RCshgkD/XtXzC8O0VoNa6fs=";

  ldflags = [
    "-s"
    "-X main.version=${finalAttrs.version}"
  ];

  # can do subPackages=["."] but checkphase is not finding the tests
  postInstall = ''
    pushd $out/bin
    find . ! -name loggo -delete
    popd
  '';

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  doInstallCheck = true;
  versionCheckProgramArg = "version";
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/aurc/loggo/releases/tag/${finalAttrs.src.tag}";
    description = "Powerful terminal app for structured log streaming";
    homepage = "https://github.com/aurc/loggo";
    license = lib.licenses.mit;
    mainProgram = "loggo";
    maintainers = with lib.maintainers; [
      ipsavitsky
      phanirithvij
    ];
  };
})
