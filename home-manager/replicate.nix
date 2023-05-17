{ config, pkgs, ... }:

{
  imports = [
    ./gcloud.nix
  ];

  home.packages = [
    pkgs.dive
    pkgs.eksctl
    pkgs.gcrane
    pkgs.kustomize
  ];
}
