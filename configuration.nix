{ config, pkgs, ... }:

{
    # System state version: Important for ensuring compatibility and stability over upgrades.
    system.stateVersion = "23.05"; # Set to the version of NixOS being installed.

    # Filesystem setup for the root partition.
    fileSystems."/" = {
        device = "/dev/disk/by-label/nixos"; # Replace with your root partition's device label.
        fsType = "ext4"; # Filesystem type, e.g., ext4, xfs, etc.
    };

    # GRUB bootloader configuration.
    boot.loader.grub = {
        enable = true; # Enable GRUB bootloader.
        device = "/dev/sda"; # Replace with the device where GRUB should be installed, typically the boot drive.
    };

    # Network configuration
    networking.hostName = "coldnixos"; # The hostname for this machine.
    networking.networkmanager.enable = true; # Enable NetworkManager for network configuration.

    # Audio configuration
    sound.enable = true; # Enable sound.
    hardware.pulseaudio.enable = false; # Disable PulseAudio (superseded by PipeWire).
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true; # Enable PipeWire for audio.
        alsa.enable = true;
        alsa.support32Bit = true;
        jack.enable = true;
    };

    # Bluetooth configuration
    hardware.bluetooth.enable = true; # Enable Bluetooth support.

    # Printer and scanner support
    services.printing.enable = true; # Enable printing system.
    services.saned.enable = true; # Enable scanner support.

    # Touchpad support (useful for laptops)
    services.xserver.libinput.enable = true; # Enable libinput for touchpad support.
    
    # Graphics drivers "nouveau" "amdgpu" "intel" "vesa"
    services.xserver.videoDrivers = ["intel"]; # List of graphics drivers to support various GPUs.

    # Kernel modules for filesystem and virtualization "xfs" "btrfs" "vfat" "ext4"
    boot.initrd.availableKernelModules = ["ext4"]; # Filesystem modules for initial ramdisk.
    boot.kernelModules = ["kvm-intel"]; # Modules for virtualization and power management. "kvm-intel" "kvm-amd" "acpi_call" 

    # CPU microcode updates
    hardware.cpu.intel.updateMicrocode = true; # Update microcode for Intel CPUs.
    hardware.cpu.amd.updateMicrocode = true; # Update microcode for AMD CPUs.

    # Wayland compositor
    programs.hyprland = {
        enable = true; # Enable Hyprland, a Wayland compositor.
        xwayland.enable = true;
    };

    environment.sessionVariables = {
        WLR_NO_HARDWARE_CURSORS = "1";
        NIXOS_OZONE_WL = "1";
    };

    xdg.portal.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

    # User configuration
    users.users.erik = {
        isNormalUser = true; # Specify that 'erik' is a regular user, not a system user.
        extraGroups = [ "wheel" ]; # Add 'erik' to 'wheel' group for sudo access.
        home = "/home/erik"; # Home directory path.
        createHome = true; # Ensure the home directory is created.
        shell = pkgs.bash; # User's shell, here set to Bash.
    };

    # Locale and timezone configuration
    i18n.defaultLocale = "en_US.UTF-8"; # Default system locale.
    time.timeZone = "Europe/Zagreb"; # System timezone.
    
    # System packages
    environment.systemPackages = with pkgs; [
        wget # A utility for non-interactive download of files from the Web.
        git # Distributed version control system.
        neovim # Vim-fork focused on extensibility and usability.
        kitty # A modern, hackable, featureful, OpenGL-based terminal emulator.
        direnv # An environment switcher for the shell.
        firefox # Web browser.
        ntfs3g # NTFS read-write support driver
        waybar
        dunst
        libnotify
        rofi-wayland
        (pkgs.waybar.overrideAttrs (oldAttrs: {
                mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
            })
        )
        swww
    ];

    # Font configuration
    fonts.fonts = with pkgs; [
        ubuntu_font_family # Ubuntu font family.
        nerdfonts # Nerd Fonts collection.
    ];

    console = {
        font = "Lat2-Terminus16";
        keyMap = "us";
    };

    # Nix Flakes configuration
    nix = {
        package = pkgs.nixFlakes; # Set the Nix package to Nix with Flakes support.
        extraOptions = "experimental-features = nix-command flakes"; # Enable experimental features for Flakes.
    };

    # Environment variables
    environment.variables.MOZ_ENABLE_WAYLAND = "1"; # Enable Wayland support in Firefox.
}
