{ config, pkgs, ...}:
{
  home.packages = [
    pkgs.python3Packages.black
  ];

  programs.emacs = {
    enable = true;
    package = pkgs.emacs29;

    extraConfig = pkgs.lib.mkIf pkgs.stdenv.hostPlatform.isDarwin ''
      ; macOS ls doesn't support --dired
      (setq dired-use-ls-dired nil)
    '';

    extraPackages = epkgs: let
      sops = epkgs.trivialBuild {
        pname = "sops";
        version = "0.1.4";
        src = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/djgoku/sops/v0.1.4/sops.el";
          hash = "sha256-GmEexfdDLQfgUQ2WrVo/C9edF9/NuocO3Dpnv3F7/qA=";
        };
      };
    in
      with epkgs; [
        org

        better-defaults
        diminish
        epkgs."ido-completing-read+"
        smex

        # epkgs.exec-path-from-shell

        flycheck

        envrc

        blacken
        company
        dockerfile-mode
        emacsql
        go-mode
        haskell-mode
        kubel
        lsp-mode
        lsp-pyright
        lsp-ui
        lua-mode
        magit
        markdown-mode
        nix-mode
        nix-sandbox
        pretty-mode
        projectile
        rust-mode
        sops
        terraform-mode
        yaml-mode
      ];
  };

  home.file.".emacs.d/init.el" = {
    source = ./emacs/init.el;
  };
  home.file.".emacs.d/config.org" = {
    source = ./emacs/config.org;
  };
}
