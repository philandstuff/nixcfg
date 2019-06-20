{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot efi boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.tmpOnTmpfs = true;

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
    chromium curl emacs firefox git gnupg
    go htop
    openjdk8 pass sakura wget yubikey-personalization
  ];

  environment.variables = {
    GOROOT = [ "${pkgs.go.out}/share/go" ];
  };

  programs.bash.enableCompletion = true;

  hardware.cpu.intel.updateMicrocode = true;
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
  fonts.fontconfig.dpi = 192;

#  services.xserver.desktopManager.default = "none";
  services.xserver.desktopManager.gnome3 = {
    enable = true;
    extraGSettingsOverrides = ''
      [org.gnome.desktop.peripherals.touchpad]
      tap-to-click=false
      [org.gnome.desktop.input-sources]
      xkb-options=['caps:ctrl_modifier']
      sources=[('xkb', 'uk')]
    '';
  };
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.sessionCommands = ''
    gpg-connect-agent /bye
    GPG_TTY=$(tty)
    export GPG_TTY

    # default sensitivity for trackpoint is too low. this fixes it.
    xinput set-prop 'PS/2 Synaptics TouchPad' 'libinput Accel Speed' 0.7
  '';

  services.xserver.synaptics.enable = false;
  services.xserver.libinput = {
    enable = true;
    naturalScrolling = true;
    scrollMethod = "twofinger";
    tapping = false;
    # scrollButton = 3;
  };

  time.timeZone = "Europe/London";

  users.extraGroups.emfbadge = {};

  users.extraUsers.philandstuff = {
    isNormalUser = true;
    extraGroups = [ "dialout" "docker" "emfbadge" "libvirtd" "networkmanager" "wheel" ];
  };

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
}
