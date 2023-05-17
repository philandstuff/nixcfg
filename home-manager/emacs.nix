{ config, pkgs, ...}:

{
  home.packages = [
    pkgs.python3Packages.black
  ];

  programs.emacs = {
    enable = true;

    extraConfig = pkgs.lib.mkIf pkgs.stdenv.hostPlatform.isDarwin ''
      ; macOS ls doesn't support --dired
      (setq dired-use-ls-dired nil)
    '';

    extraPackages = epkgs: with epkgs; [
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
      go-mode
      haskell-mode
      lsp-mode
      lsp-ui
      magit
      markdown-mode
      nix-mode
      nix-sandbox
      pretty-mode
      projectile
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
