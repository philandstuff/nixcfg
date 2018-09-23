{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot efi boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  networking.hostId = "db0cce68";

  i18n = {
    consoleKeyMap = "uk";
    defaultLocale = "en_GB.UTF-8";
  };

  nixpkgs.config.allowUnfreePredicate = with pkgs.lib; pkg:
    any (s: hasPrefix s pkg.name) ["skype" "firefox-"];

  environment.etc.gitconfig = { text = ''
    [transfer]
        fsckObjects = true
    [fetch]
        fsckObjects = true
    [receive]
        fsckObjects = true

    # rewrite github https: urls to ssh for pushing
    [url "git@github.com:"]
        pushInsteadOf = "https://github.com/"

    [pull]
        ff = only
    
    [push]
        default = simple
  ''; };

  environment.systemPackages = with pkgs; [
    chromium curl darktable emacs firefox git gnupg
    go htop libgphoto2
    openjdk8 owncloudclient pass sakura skype wget yubikey-personalization
  ];

  programs.bash.enableCompletion = true;

  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  networking.networkmanager.enable = true;

  # automatically optimise new files as they are added to the store
  # saves lots of disk space!
  nix.extraOptions = "auto-optimise-store = true";

  services.pcscd.enable = true; # needed for yubikey OpenPGP

  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint ];
  };

  services.redshift = {
    enable = true;
    latitude = "51.0";
    longitude = "0.0";
  };

  services.syslogd.enable = true;
  services.tlp.enable = true;

  # allow yubikey access to wheel group
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0664", GROUP="wheel", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0113|0114|0115|0116|0120"
    ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE="660", GROUP="emfbadge"
  '';

  # I use gpg-agent instead of ssh-agent
  programs.ssh.startAgent = false;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "uk";
  services.xserver.xkbOptions = "ctrl:nocaps,eurosign:e";

#  services.xserver.desktopManager.default = "none";
  services.xserver.desktopManager.gnome3.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.sessionCommands = ''
    gpg-connect-agent /bye
    GPG_TTY=$(tty)
    export GPG_TTY

    unset SSH_AGENT_PID
    export SSH_AUTH_SOCK="$HOME/.gnupg/S.gpg-agent.ssh"

    # Set up trackpoint scrolling with middle button
    xinput set-prop "PS/2 Synaptics TouchPad" "Evdev Wheel Emulation" 1
    xinput set-prop "PS/2 Synaptics TouchPad" "Evdev Wheel Emulation Button" 2
    xinput set-prop "PS/2 Synaptics TouchPad" "Evdev Wheel Emulation Timeout" 200
    xinput set-prop "PS/2 Synaptics TouchPad" "Evdev Wheel Emulation Axes" 6 7 4 5
  '';
#  services.xserver.windowManager.default = "xmonad";
#  services.xserver.windowManager.xmonad.enable = true;

  services.xserver.synaptics.enable = true;

  services.xserver.synaptics = {

  time.timeZone = "Europe/London";

  users.extraGroups.emfbadge = {};

  users.extraUsers.philandstuff = {
    isNormalUser = true;
    extraGroups = [ "dialout" "emfbadge" "networkmanager" "wheel" ];
  };
}
