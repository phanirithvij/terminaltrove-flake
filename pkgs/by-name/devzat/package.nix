{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "devzat";
  version = "2c402d2";

  src = fetchFromGitHub {
    owner = "quackduck";
    repo = "devzat";
    rev = "release-${finalAttrs.version}";
    hash = "sha256-M/9jX+lwGxVcPMvuGZh7deVFK8lYn661yxhsFoXnfq8=";
  };

  vendorHash = "sha256-52Ok29n2WuWBV+OEKUbmVjvlg+IEqegxH89DubAVsdU=";

  env.CGO_ENABLED = "0";

  ldflags = [ "-s" ];

  excludedPackages = [
    "./devzatapi"
    "./plugin"
  ];

  meta = {
    changelog = "https://github.com/quackduck/devzat/releases/tag/release-${finalAttrs.version}";
    description = "Custom SSH server to chat over SSH";
    homepage = "https://github.com/quackduck/devzat";
    license = lib.licenses.mit;
    mainProgram = "devzat";
    maintainers = with lib.maintainers; [ phanirithvij ];
  };
})
