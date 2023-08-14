{ config, pkgs, ... }:

{
  imports = [
    ./gcloud.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home.packages = [
    pkgs._1password
    pkgs.dive
    pkgs.eksctl
    pkgs.flyctl
    pkgs.gcrane
    pkgs.heroku
    pkgs.kind
    pkgs.kubernetes-helm
    pkgs.kustomize
    pkgs.rclone
    pkgs.redis # for cli
    pkgs.s3cmd
    pkgs.sops
    pkgs.stern
  ];
}
