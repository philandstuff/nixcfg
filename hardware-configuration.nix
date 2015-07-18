{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_hcd" "ehci_pci" "ahci" "usb_storage" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModprobeConfig = ''
    options psmouse proto=imps
  '';

  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices = [
    { name = "luksroot"; device = "/dev/sda3"; }
  ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/23c65c6f-99af-4c86-9874-7b970c47fd1a";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/4730-FE61";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/mapper/nixos-swap"; }
    ];

  nix.maxJobs = 4;
}
