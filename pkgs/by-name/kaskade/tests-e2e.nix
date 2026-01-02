{
  lib,
  pkgs,
  ...
}:
{
  name = "Kaskade e2e tests";

  nodes = {
    machine =
      { ... }:
      let
        # TODO some json file + update script combo
        # nix run nixpkgs#nix-prefetch-docker -- --image-name confluentinc/cp-kafka --image-tag 8.1.0
        confluentImage = pkgs.dockerTools.pullImage {
          imageName = "confluentinc/cp-kafka";
          imageDigest = "sha256:9026dbbf280d41868b95ae3995e1fdf0f5db5964776fb9581b52a02e3776d727";
          hash = "sha256-3umJ6ds308ZrId8MlamJMtaMw2XmCwXBqw018mpEYhw=";
          finalImageName = "confluentinc/cp-kafka";
          finalImageTag = "8.1.0";
        };
        # nix run nixpkgs#nix-prefetch-docker -- --image-name redpandadata/redpanda --image-tag v25.2.10
        redpandaImage = pkgs.dockerTools.pullImage {
          imageName = "redpandadata/redpanda";
          imageDigest = "sha256:8f9e1e944ba5ba21c5bd60877d0d267d8ac6e4d07e12509424197deb43c0ada5";
          hash = "sha256-xJI41jMvz3EF2/jLr/wh7fAKIcft/q5izXvId9CbZ7w=";
          finalImageName = "redpandadata/redpanda";
          finalImageTag = "v25.2.10";
        };
        # nix run nixpkgs#nix-prefetch-docker -- --image-name testcontainers/ryuk --image-tag 0.8.1
        testcontainersRyukImage = pkgs.dockerTools.pullImage {
          imageName = "testcontainers/ryuk";
          imageDigest = "sha256:bf3f74a47dee0acda89aba4b2fc9c7fdcf994a084db02a2d06566f07baae022e";
          hash = "sha256-vFMgBB0BM7M0YxgodDYUQL7GemRuCccMsBhFDS3UhpA=";
          finalImageName = "testcontainers/ryuk";
          finalImageTag = "0.8.1";
        };
      in
      {
        virtualisation.memorySize = 4096; # kafka needs some memory
        virtualisation.diskSize = 4096; # needs some storage
        virtualisation.cores = 4; # optional
        virtualisation.docker.enable = true;

        environment.systemPackages = [
          pkgs.python3
          pkgs.skopeo
          (pkgs.writeShellScriptBin "tests_e2e" (
            let
              pythonPath =
                with pkgs.python3Packages;
                [
                  pkgs.kaskade
                ]
                ++ pkgs.kaskade.dependencies
                ++ [
                  parameterized
                  testcontainers
                ];
              # inspired from nix2container, nix-prefetch-docker
              copyToDockerDaemon =
                image:
                # bash
                ''
                  echo "Copy to Docker daemon image ${image.imageName}:${image.imageTag}"
                  skopeo \
                    --insecure-policy \
                    --override-os "linux" \
                    --override-arch ${pkgs.go.GOARCH} \
                    copy \
                    --src-tls-verify=true \
                    "docker-archive://${image}" \
                    "docker-daemon:${image.imageName}:${image.imageTag}" "$@" \
                  | cat  # pipe through cat to force-disable progress bar
                '';
            in
            # bash
            ''
              ${copyToDockerDaemon confluentImage}
              ${copyToDockerDaemon redpandaImage}
              ${copyToDockerDaemon testcontainersRyukImage}

              export PYTHONPATH=${pkgs.python3Packages.makePythonPath pythonPath}
              cd $(mktemp -d)
              cp -r --no-preserve=all ${pkgs.srcOnly pkgs.kaskade} source
              cd source
              python -m scripts.tests --e2e
            ''
          ))
        ];
      };
  };

  testScript =
    { nodes, ... }:
    # py
    ''
      # start
      start_all()
      machine.wait_for_unit("multi-user.target")

      machine.succeed("tests_e2e | systemd-cat")
    '';

  # Debug interactively with:
  # - nix build -L .#kaskade.passthru.tests.e2e.driverInteractive
  # - start_all() / run_tests()
  interactive.sshBackdoor.enable = true; # ssh -o User=root vsock%3
  interactive.nodes.machine =
    { config, ... }:
    {
      virtualisation.graphics = false;
      environment.systemPackages = with pkgs; [
        lf
        btop
        sysz
      ];
    };
}
