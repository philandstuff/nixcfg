{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the gummiboot efi boot loader.
  boot.loader.gummiboot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  networking.hostId = "db0cce68";

  i18n = {
    consoleKeyMap = "uk";
    defaultLocale = "en_GB.UTF-8";
  };

  nixpkgs.config.allowUnfreePredicate = with pkgs.lib; pkg:
    any (s: hasPrefix s pkg.name) ["skype-" "firefox-"];

  environment.etc.gitconfig = { text = ''
    [transfer]
        fsckObjects = true
    [fetch]
        fsckObjects = true
    [receive]
        fsckObjects = true
  ''; };

  environment.systemPackages = with pkgs; [
    chromium curl darktable emacs evilvte firefoxWrapper git gnupg
    htop libgphoto2 mongodb
    openjdk8 owncloudclient pass skype wget ykpers
  ];

  nixpkgs.config.evilvte.config = ''
    #define BACKGROUND_SATURATION 0.15
    #define BACKGROUND_OPACITY TRUE
    #define COLOR_STYLE ZENBURN_DARK
    #define COMMAND_AT_ROOT_WINDOW TRUE
    #define COMMAND_DOCK_MODE TRUE
    #define COMMAND_EXEC_PROGRAM TRUE
    #define COMMAND_FULLSCREEN TRUE
    #define COMMAND_FONT TRUE
    #define COMMAND_GEOMETRY TRUE
    #define COMMAND_LOGIN_SHELL TRUE
    #define COMMAND_SET_TITLE TRUE
    #define COMMAND_SHOW_HELP TRUE
    #define COMMAND_SHOW_OPTIONS TRUE
    #define COMMAND_SHOW_VERSION TRUE
    #define COMMAND_TAB_NUMBERS TRUE
    /* #define FONT "Pragmata Pro 15" */
    #define FONT_ANTI_ALIAS TRUE
    #define FONT_ENABLE_BOLD_TEXT TRUE
    #define MOUSE_CTRL_SATURATION TRUE
    #define SCROLL_LINES 100000
    #define SCROLLBAR OFF_R
    #define SHOW_WINDOW_BORDER FALSE
    #define SHOW_WINDOW_DECORATED TRUE
    #define SHOW_WINDOW_ICON TRUE
    #define WORD_CHARS "-A-Za-z0-9_$.+!*(),;:@&=?/~#%"
    #define TAB TRUE
    #define TAB_NEW_PATH_EQUAL_OLD TRUE
    #define TAB_SHOW_INFO_AT_TITLE TRUE
    #define TABBAR FALSE
    #define HOTKEY TRUE
    #define HOTKEY_COPY ALT(GDK_C) || ALT(GDK_c)
    #define HOTKEY_PASTE ALT(GDK_V) || ALT(GDK_v)
    #define HOTKEY_FONT_BIGGER ALT(GDK_plus)
    #define HOTKEY_FONT_SMALLER ALT(GDK_minus)
    #define HOTKEY_FONT_DEFAULT_SIZE ALT(GDK_0)
    #define HOTKEY_TAB_ADD CTRL_SHIFT(GDK_T) || CTRL_SHIFT(GDK_t)
    #define HOTKEY_TAB_REMOVE CTRL_SHIFT(GDK_W) || CTRL_SHIFT(GDK_w)
    #define HOTKEY_TAB_PREVIOUS CTRL_ALT(GDK_Page_Up)
    #define HOTKEY_TAB_NEXT CTRL_ALT(GDK_Page_Down)
  '';

  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint ];
  };

  services.syslogd.enable = true;
  services.redshift = {
    enable = true;
    latitude = "51.0";
    longitude = "0.0";
  };

  services.pcscd.enable = true; # needed for yubikey OpenPGP

  # allow yubikey access to wheel group
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0664", GROUP="wheel", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0113|0114|0115|0116|0120"
  '';

  # use gpg-agent
  programs.ssh.startAgent = false;
  services.xserver.startGnuPGAgent = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "uk";
  services.xserver.xkbOptions = "ctrl:nocaps,eurosign:e";

#  services.xserver.desktopManager.default = "none";
  services.xserver.desktopManager.gnome3.enable = true;
  services.xserver.displayManager.desktopManagerHandlesLidAndPower = false;
  services.xserver.displayManager.gdm.enable = true;
#  services.xserver.windowManager.default = "xmonad";
#  services.xserver.windowManager.xmonad.enable = true;

  services.xserver.synaptics.enable = true;

  time.timeZone = "Europe/London";

  users.extraUsers.philandstuff = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
  };
}
