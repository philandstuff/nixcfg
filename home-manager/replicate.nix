{ config, pkgs, ... }:

{
  imports = [
    ./gcloud.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home.packages = [
    pkgs._1password
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
    pkgs.rclone
    pkgs.redis # for cli
    pkgs.s3cmd
    pkgs.sops
    pkgs.stern
  ];
}
