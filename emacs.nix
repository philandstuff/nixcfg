{ config, pkgs, ...}:

{
  programs.emacs = {
    enable = true;
    extraConfig = ''
      (require 'better-defaults)

      (ido-mode 1)
      (ido-everywhere 1)
      (ido-ubiquitous-mode 1)

      (require 'smex)
      (setq smex-save-file (concat user-emacs-directory ".smex-items"))
      (smex-initialize)
      (global-set-key (kbd "M-x") 'smex)

      (global-set-key "\C-cg" 'magit-status)

      (defalias 'yes-or-no-p 'y-or-n-p)

      (set-default 'indicate-empty-lines t)

      (when (string-equal system-type "gnu/linux")
        (setq x-super-keysym 'meta))

      (global-unset-key (kbd "C-z"))

      (put 'narrow-to-region 'disabled nil)
      (put 'upcase-region 'disabled nil)

      (setq visible-bell nil)
      (setq ring-bell-function
            (lambda ()
              (invert-face 'mode-line)
              (run-with-timer 0.1 nil 'invert-face 'mode-line)))

      (require 'flycheck)
      (add-hook 'after-init-hook #'global-flycheck-mode)
      (diminish 'flycheck-mode)

      (global-pretty-mode 1)

      ;; Set up before-save hooks to format buffer and add/delete imports.
      ;; Make sure you don't have other gofmt/goimports hooks enabled.
      (defun lsp-go-install-save-hooks ()
        (add-hook 'before-save-hook #'lsp-format-buffer t t)
        (add-hook 'before-save-hook #'lsp-organize-imports t t))
      (add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

      (add-hook 'markdown-mode-hook (lambda ()
                                      (variable-pitch-mode 1)
                                      (visual-line-mode 1)))

      (projectile-mode +1)
      (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
      (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
      (diminish 'projectile-mode)

      (eval-after-load 'terraform-mode
        '(add-hook 'terraform-mode-hook #'terraform-format-on-save-mode))
    '';
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
}
