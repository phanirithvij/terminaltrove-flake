{
  lib,
  buildGoModule,
  fetchFromGitHub,

  zlib,
  elfutils,
  pkg-config,
  clangStdenv,
  llvmPackages,

  ebpf-go,
}:
let
  # required because generated code is version dependent
  ebpf-go' = ebpf-go.overrideAttrs (
    final: prev: {
      version = "0.16.0"; # from go.mod of kyanos
      src = fetchFromGitHub {
        inherit (prev.src) owner repo;
        tag = "v${final.version}";
        hash = "sha256-8WUmFbXOZuMex1R6X00DUzEe0QO0KRdsKxA0AJ7WfNw=";
      };
      vendorHash = "sha256-b4bd7K7e7YIpFma2zkRzQe3VO8UUuaoQqlS5G2t6qFE=";
    }
  );
in
buildGoModule.override { stdenv = clangStdenv; } (finalAttrs: {
  pname = "kyanos";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "hengyoush";
    repo = "kyanos";
    rev = "v${finalAttrs.version}";
    hash = "sha256-UH6mqFQnib8RITbqxjtcQA1nwabS70v/o7dMXQyjTbk=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-wsTS61yfOuKtNRcM5GdxIZvwTgnUJT/wWLUuqjhwO+o=";

  nativeBuildInputs = [
    pkg-config
    llvmPackages.bintools # buildInputs?
    ebpf-go'
  ];

  buildInputs = [
    elfutils # not libelf, see https://github.com/libbpf/libbpf/issues/784
    zlib
  ];

  preBuild = ''
    substituteInPlace bpf/gen.go \
      --replace-fail "go run github.com/cilium/ebpf/cmd/bpf2go" "bpf2go"
    make build-bpf
  '';

  # this breaks go generate as bpf does not support -fzero-call-used-regs=used-gpr
  hardeningDisable = [ "zerocallusedregs" ];

  overrideModAttrs = (
    finalAttrs: prevAttrs: {
      # don't run prebuild in the module fetch phase
      preBuild = "";
    }
  );

  ldflags = [
    "-s"
    "-X=kyanos/version.Version=${finalAttrs.version}"
    "-X=kyanos/version.CommitID=${finalAttrs.src.rev}"
    "-X=kyanos/version.BuildTime=1970-01-01T00:00:00Z"
    # TODO figure out static linking
    #"-linkmode=external"
    #"-extldflags '-static'"
  ];

  #env.CGO_LDFLAGS = "-Xlinker -rpath=. -static";

  # level=error msg="Kyanos requires CAP_BPF to run. Please run kyanos with sudo or run container in privilege mode."
  # TODO nixos test
  doCheck = false;

  meta = {
    changelog = "https://github.com/hengyoush/kyanos/releases/tag/v${finalAttrs.version}";
    description = "eBPF-based network issue analysis tool";
    homepage = "https://kyanos.io";
    downloadPage = "https://github.com/hengyoush/kyanos";
    license = lib.licenses.asl20;
    mainProgram = "kyanos";
    maintainers = with lib.maintainers; [ phanirithvij ];
    platforms = lib.platforms.linux;
  };
})
