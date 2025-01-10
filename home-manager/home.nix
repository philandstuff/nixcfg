{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "philandstuff";
  home.homeDirectory = "/Users/philandstuff";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    ./emacs.nix
    ./yubikey-agent.nix
    ./replicate.nix
  ];

  launchd.enable = true;

  home.sessionVariables.NIX_CONFIG = "extra-experimental-features = nix-command flakes";

  home.packages = [
    pkgs.asdf-vm
    pkgs.git-filter-repo
    pkgs.imgcat
    pkgs.jq
    pkgs.magic-wormhole
    pkgs.pre-commit
    pkgs.pwgen
    pkgs.shellcheck
    pkgs.sqlite-interactive
    pkgs.watch
    pkgs.wcurl
  ];

  programs = {
    direnv.enable = true;
    fzf.enable = true;
    starship.enable = true;

    git = {
      enable = true;
      lfs.enable = true;
      userName = "Philip Potter";
      userEmail = "philip.g.potter@gmail.com";

      aliases = {
        st = "status -bs";
      };

      includes = [
        {
          condition = "gitdir:~/replicate/";
          contents = {
            user = {
              email = "phil@replicate.com";
            };
          };
        }
      ];
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        remote = {
          pushDefault = "origin";
        };
      };
    };

    zsh = {
      enable = true;
      initExtra = ''
        export PATH=$PATH:$HOME/go/bin
        . ${pkgs.asdf-vm}/share/asdf-vm/asdf.sh
        if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
          . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
        fi

        # increase open file limit from the measly default of 256
        ulimit -n 1000000
      '';
    };
  };
}
