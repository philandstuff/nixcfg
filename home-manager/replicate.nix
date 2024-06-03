{ config, pkgs, cbcli, ... }:

{
  imports = [
    ./gcloud.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home.packages = [
    pkgs._1password
    pkgs.awscli2
    pkgs.amazon-ecr-credential-helper
    pkgs.cmctl
    pkgs.dive
    pkgs.eksctl
    pkgs.flyctl
    pkgs.gcrane
    pkgs.gh
    pkgs.heroku
    pkgs.k9s
    pkgs.kind
    pkgs.kubernetes-helm
    pkgs.kustomize
    pkgs.oci-cli # ugh
    pkgs.postgresql
    pkgs.rclone
    pkgs.redis # for cli
    pkgs.s3cmd
    pkgs.sops
    pkgs.stern
    pkgs.tailscale

    cbcli.default
  ];
}
