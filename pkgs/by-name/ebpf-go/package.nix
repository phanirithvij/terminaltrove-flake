{
  lib,
  buildGoModule,
  fetchFromGitHub,

  clang,
  clangStdenv,
  llvmPackages,
}:
buildGoModule.override { stdenv = clangStdenv; } (finalAttrs: {
  pname = "ebpf-go";
  version = "0.20.0";
  src = fetchFromGitHub {
    owner = "cilium";
    repo = "ebpf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rb2fkVF5/fQLzil+Ns8VeeC785kFWLWrDt92VNcMWk0=";
  };

  vendorHash = "sha256-PEkr+uL/hO2fKYGt+IgRghWFH75mv54uyhi0D3JPhAc=";

  subPackages = [ "cmd/bpf2go" ];

  ldflags = [
    "-s"
  ];

  doCheck = false; # TODO go test -v -exec sudo ./... maybe just ./cmd/bpf2go
  nativeCheckInputs = [
    clang
    llvmPackages.bintools
  ];

  hardeningDisable = [ "zerocallusedregs" ];

  meta = {
    changelog = "https://github.com/cilium/ebpf/releases/tag/v${finalAttrs.version}";
    description = "pure-Go library to read, modify and load eBPF programs and attach them to various hooks in the Linux kernel.";
    downloadPage = "https://github.com/cilium/ebpf";
    homepage = "https://ebpf-go.dev/";
    license = lib.licenses.mit;
    mainProgram = "ebpf2go";
    maintainers = with lib.maintainers; [ phanirithvij ];
    platforms = lib.platforms.linux;
  };
})
