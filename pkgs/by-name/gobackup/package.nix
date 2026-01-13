{
  lib,
  stdenvNoCC,
  buildGoModule,
  fetchFromGitHub,

  jq,
  nodejs,
  moreutils,
  fetchYarnDeps,
  yarnBuildHook,
  yarnConfigHook,

  versionCheckHook,
}:
let
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "gobackup";
    repo = "gobackup";
    tag = "v${version}";
    hash = "sha256-9h5+JKYU2dlHznvWDkVOG7VSNiKsPd7z3AQm8Wh8LD4=";
  };

  frontend = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "gobackup-frontend";
    inherit src version;
    sourceRoot = "${src.name}/web";
    yarnOfflineCache = fetchYarnDeps {
      yarnLock = "${src}/web/yarn.lock";
      hash = "sha256-LkPg6Hwriq/VBEVfq0B9ZTcLdwxQRaLYhgdxgcUD+rU=";
    };
    react-virtualized-fixed = fetchFromGitHub {
      tag = "9.22.3"; # from web/package.json
      owner = "remorses";
      repo = "react-virtualized-fixed-import";
      hash = "sha256-mMZWDoFkGIMkmv80s1E8q9bnU8jVDa7H9tX0BuwAj0k=";
    };
    postUnpack = ''
      pushd $sourceRoot || exit 1
      rm package-lock.json
      jq \
        '.resolutions["react-virtualized"] = "file://${finalAttrs.react-virtualized-fixed}"' \
        package.json | sponge package.json
      popd || exit 1
    '';
    nativeBuildInputs = [
      jq
      nodejs
      moreutils
      yarnConfigHook
      yarnBuildHook
    ];
    installPhase = ''
      runHook preInstall
      mv dist $out
      runHook postInstall
    '';
  });
in
buildGoModule (finalAttrs: {
  pname = "gobackup";
  inherit src version;

  vendorHash = "sha256-tUF1tix0NIgreKC/nYbOZvayFsKg4lsMdPKBEIkeU/M=";

  overrideModAttrs = _: _: { preBuild = ""; };

  preBuild = ''
    cp -r ${finalAttrs.passthru.frontend} web/dist
  '';

  ldflags = [
    "-s"
    "-X=main.version=${version}"
  ];

  doInstallCheck = true;
  versionCheckProgramArg = "--version";
  nativeInstallCheckInputs = [ versionCheckHook ];

  # tests which require network access
  disabledTests = [ "Test_WxWorkNotify" ];

  checkFlags = [ "-skip ${lib.concatStringsSep "|" finalAttrs.disabledTests}" ];

  passthru = { inherit frontend; };

  meta = {
    changelog = "https://github.com/gobackup/gobackup/releases/tag/${finalAttrs.src.tag}";
    description = "CLI tool for backing up your databases, files to cloud storages in schedully";
    homepage = "https://gobackup.github.io/";
    downloadPage = "https://github.com/gobackup/gobackup";
    license = lib.licenses.mit;
    mainProgram = "gobackup";
    maintainers = with lib.maintainers; [ phanirithvij ];
  };
})
