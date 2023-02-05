{ config, pkgs, ...}:

{
  programs.emacs = {
    enable = true;
    extraConfig = ''
      (require 'better-defaults)
      (defalias 'yes-or-no-p 'y-or-n-p)
    '';
    extraPackages = epkgs: [
      epkgs.nix-mode
      epkgs.magit
      epkgs.better-defaults
    ];
  };

}
