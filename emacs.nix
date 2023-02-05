{ config, pkgs, ...}:

{
  programs.emacs = {
    enable = true;

    extraPackages = epkgs: with epkgs; [
      org

      better-defaults
      diminish
      epkgs."ido-completing-read+"
      smex

      # epkgs.exec-path-from-shell

      flycheck
      
      lsp-mode
      lsp-ui
      company
      haskell-mode
      pretty-mode
      nix-mode
      nix-sandbox
      magit
      markdown-mode
      projectile
      terraform-mode
    ];
  };

  home.file.".emacs.d/init.el" = {
    source = ./emacs/init.el;
  };
  home.file.".emacs.d/config.org" = {
    source = ./emacs/config.org;
  };
}
