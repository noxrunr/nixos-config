{ config, pkgs, ... }:

{

    # imports = [ <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal> ];

    system.stateVersion = "23.05"; # Adjust according to your NixOS version

    fileSystems."/" = {
        device = "/dev/disk/by-label/nixos"; # Replace with your actual root partition
        fsType = "ext4"; # Replace with your file system type
    };

    boot.loader.grub = {
        enable = true;
        device = "/dev/sda"; # Replace with your actual boot device
    };

    # Network configuration
    networking.hostName = "coldnixos";
    networking.networkmanager.enable = true; # Enable networking features

    # Enable audio
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    services.pipewire = {
        enable = true;
    };

    # Enable bluetooth
    hardware.bluetooth.enable = true;

    # Enable using printers and scanners
    services.printing.enable = true;
    services.saned.enable = true;

    # Enable touchpad (if on laptop)
    services.xserver.libinput.enable = true;
    
    # Enable a graphics driver (choose needed or leave all to use on any system)
    services.xserver.videoDrivers = [ "nouveau" "amdgpu" "intel" "vesa"];

    # Filesystem (enable extra filesystem support if needed)
    boot.initrd.availableKernelModules = [ "xfs" "ntfs" "btrfs" "vfat" "ext4"];
    boot.kernelModules = [ "kvm-intel" "kvm-amd" "acpi_call" ];

    # CPU microcode updates
    hardware.cpu.intel.updateMicrocode = true;
    hardware.cpu.amd.updateMicrocode = true;

    # Enable Hyprland (Wayland compositor) from nixpkgs
    programs.hyprland.enable = true;

    # Create user/s
    users.users.erik = {
        isNormalUser = true;
        extraGroups = [ "wheel" ]; # Enables sudo for the user
        home = "/home/erik";
        createHome = true;
        shell = pkgs.bash;
    };

    # System locale
    i18n.defaultLocale = "en_US.UTF-8";
    time.timeZone = "Europe/Zagreb";

    # Packages to install
    environment.systemPackages = with pkgs; [
        wget
        git
        neovim
        kitty
        direnv
        vscode
        firefox
    ];

    # Fonts
    fonts.fonts = with pkgs; [
        ubuntu_font_family
        (nerdfonts.override { fonts = [ "Cartograph" "B612Mono" "Maple" ]; })
    ];

    # Enable Flakes
    nix = {
        package = pkgs.nixFlakes;
        extraOptions = "experimental-features = nix-command flakes";
    };

    # Environment variables
    environment.variables.MOZ_ENABLE_WAYLAND = "1";

}