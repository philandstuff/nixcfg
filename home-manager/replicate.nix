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

    pkgs.protobuf
    pkgs.protoc-gen-go
    pkgs.protoc-gen-go-grpc

    cbcli.default
  ];
}
