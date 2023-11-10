{ config, pkgs, ... }:

{

    # imports = [ <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal> ];

    # Network configuration
    networking.hostName = "coldnixos";
    networking.networkmanager.enable = true; # Enable networking features
    networking.wireless.enable = true;

    # Enable audio
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    hardware.pipewire.enable = true;

    # Enable bluetooth
    hardware.bluetooth.enable = true;
    services.bluetooth.bluez.enable = true;

    # Enable using printers and scanners
    services.printing.enable = true;
    services.sane.enable = true;

    # Enable touchpad (if on laptop)
    services.xserver.libinput.enable = true;
    
    # Enable a graphics driver (choose needed or leave all to use on any system)
    services.xserver.videoDrivers = [ "nouveau" "amdgpu" "intel" "vesa"];

    # Filesystem (enable extra filesystem support if needed)
    boot.initrd.availableKernelModules = [ "xfs" "ntfs" "btrfs" "vfat" ];
    boot.kernelModules = [ "kvm-intel" "kvm-amd" "acpi_call" ];

    # CPU microcode updates
    hardware.cpu.intel.updateMicrocode = true;
    hardware.cpu.amd.updateMicrocode = true;

    # Enable Hyprland (Wayland compositor) from nixpkgs
    services.hyprland.enable = true;

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
        vscode
        firefox
    ];

    # Fonts
    fonts.packages = with pkgs; [
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