{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "vostro";
  networking.hostId = "8b27dc02";

  i18n = {
    consoleKeyMap = "uk";
    defaultLocale = "en_GB.UTF-8";
  };

  environment.systemPackages = with pkgs; [
    chromium curl dwm emacs firefox git gnupg openjdk owncloudclient polkit_gnome wget xscreensaver ykpers
  ];

  programs.ssh.startAgent = true;
  programs.ssh.agentTimeout = "1h";

  security.pam.enableU2F = true;

  services.logind.extraConfig = ''
    HandleLidSwitch=ignore
  '';

  services.syslogd.enable = true;

  # allow yubikey access to wheel group
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0664", GROUP="wheel", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0113|0114|0115|0116|0120"
  '';

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "uk";
  services.xserver.xkbOptions = "ctrl:nocaps,eurosign:e";

#  services.xserver.desktopManager.default = "none";
  services.xserver.desktopManager.gnome3.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
#  services.xserver.windowManager.default = "xmonad";
  services.xserver.windowManager.xmonad.enable = true;

  services.xserver.synaptics.enable = true;

  time.timeZone = "Europe/London";

  users.extraUsers.philandstuff = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
  };
}
