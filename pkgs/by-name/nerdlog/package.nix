# Extends the nixpkgs pr https://github.com/NixOS/nixpkgs/pull/408290

{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,

  libX11,

  tmux,
  gawk,
  which,
  runtimeShell,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  xvfb-run,

  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "nerdlog";
  version = "1.10.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dimonomid";
    repo = "nerdlog";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XlzWNeyd+Ar4ArFcN1wkQ0aod6ckAiIb12odK7cf4+s=";
  };

  vendorHash = "sha256-hvv0dsE1yz85VLaBOE7RWbux8L8kVTihcA1HyyHRYAM=";

  subPackages = [ "cmd/nerdlog" ];

  buildInputs = [ libX11 ];

  # fixes clipboard functionality on linux
  postConfigure = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace \
      vendor/golang.design/x/clipboard/clipboard_linux.c --replace-fail \
        "libX11.so" "${lib.getLib libX11}/lib/libX11.so"
  '';

  ldflags = [
    "-s"
    "-X github.com/dimonomid/nerdlog/version.version=${finalAttrs.version}"
    "-X github.com/dimonomid/nerdlog/version.commit=${finalAttrs.src.rev}"
    "-X github.com/dimonomid/nerdlog/version.date=1970-01-01T00:00:00Z"
    "-X github.com/dimonomid/nerdlog/version.builtBy=nix"
  ];

  nativeCheckInputs = [
    tmux
    gawk
    which
  ];

  doCheck = false;

  # Tests need the path to the binary
  preCheck = ''
    export NERDLOG_E2E_TEST_NERDLOG_BINARY="$NIX_BUILD_TOP/go/bin/nerdlog"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  preInstallCheck = ''
    cat <<EOF > xvfb-wrapper.sh
    #!${runtimeShell}
    exec ${lib.getExe xvfb-run} "$out/bin/nerdlog" "\$@"
    EOF
    chmod +x xvfb-wrapper.sh
    export versionCheckProgram="$PWD/xvfb-wrapper.sh"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/dimonomid/nerdlog/releases/tag/v${finalAttrs.version}";
    description = "Fast, remote-first, multi-host TUI log viewer with timeline histogram and no central server";
    homepage = "https://github.com/dimonomid/nerdlog";
    license = lib.licenses.bsd2;
    mainProgram = "nerdlog";
    maintainers = with lib.maintainers; [ paepcke ];
  };
})
