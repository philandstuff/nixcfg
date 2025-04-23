{ config, pkgs, ... }:

let cbcli = pkgs.stdenv.mkDerivation {
      name = "cbcli-v3.6.4";
      src = pkgs.fetchurl {
        url = "https://github.com/CrunchyData/bridge-cli/releases/download/v3.6.4/cb-v3.6.4_macos_arm64.zip";
        sha256 = "14h9lf1sf4abybrcs3x339nivk978zr0pd4rlql15kpv0dkix010";
      };
      phases = ["installPhase" "patchPhase"];
      nativeBuildInputs = [ pkgs.unzip ];
      installPhase = ''
        mkdir -p $out/bin
        cd $out/bin
        unzip $src
      '';
    };
in
{
  imports = [
    ./gcloud.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home.packages = [
    pkgs._1password-cli
    pkgs.awscli2
    pkgs.amazon-ecr-credential-helper
    pkgs.cmctl
    pkgs.dive
    pkgs.eksctl
    pkgs.flyctl
    pkgs.gcrane
    pkgs.gh
    pkgs.graphviz
    pkgs.heroku
    pkgs.k9s
    pkgs.kind
    pkgs.kubectl
    pkgs.kubernetes-helm
    pkgs.kustomize
    pkgs.postgresql
    pkgs.rclone
    pkgs.redis # for cli
    pkgs.s3cmd
    pkgs.sops
    pkgs.stern

    cbcli
  ];
}
