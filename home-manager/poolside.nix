{ config, lib, pkgs, ... }:

{
  imports = [
    ./gcloud.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home.packages = [
    pkgs.awscli2
    pkgs.amazon-ecr-credential-helper
    pkgs.bazelisk
    pkgs.cmctl
    pkgs.dive
    pkgs.eksctl
    pkgs.flyctl
    pkgs.gcrane
    pkgs.gh
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
  ];

  programs.zsh = {
    initContent = lib.mkAfter ''
      alias bondictl="~/Code/poolsideai/forge/bazel-bin/cmd/bondictl/bondictl_/bondictl"
      alias infer="~/Code/poolsideai/forge/bazel-bin/cmd/infer/infer_/infer"
      alias infractl="~/Code/poolsideai/forge/bazel-bin/cmd/infractl/infractl_/infractl"
      alias splash="~/Code/poolsideai/forge/bazel-bin/cmd/splash/splash_/splash"
    '';
  };
}
