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
    security.rtkit.enable = true; # Enable RealtimeKit for managing real-time priorities for user processes.
    services.pipewire = {
        enable = true; # Enable PipeWire for audio.
        alsa.enable = true; # Enable ALSA support in PipeWire for compatibility.
        alsa.support32Bit = true; # Enable 32-bit ALSA support.
        jack.enable = true; # Enable JACK support in PipeWire.
    };

    # Bluetooth configuration
    hardware.bluetooth.enable = true; # Enable Bluetooth support.

    # Printer and scanner support
    services.printing.enable = true; # Enable printing system.
    services.saned.enable = true; # Enable scanner support.

    # Touchpad support (useful for laptops)
    services.xserver.libinput.enable = true; # Enable libinput for touchpad support.
    
    # Graphics drivers configuration
    services.xserver.videoDrivers = ["intel"]; # Use Intel video drivers.

    # Kernel modules for filesystem and virtualization
    boot.initrd.availableKernelModules = ["ext4"]; # Include ext4 module in initial ramdisk.
    boot.kernelModules = ["kvm-intel"]; # Include Intel KVM module for virtualization.

    # CPU microcode updates
    hardware.cpu.intel.updateMicrocode = true; # Update microcode for Intel CPUs.
    hardware.cpu.amd.updateMicrocode = true; # Update microcode for AMD CPUs (may not be necessary if you're only using Intel CPUs).

    # Wayland compositor
    programs.hyprland = {
        enable = true; # Enable Hyprland, a Wayland compositor.
        xwayland.enable = true; # Enable XWayland for legacy X11 application support.
    };

    # Additional environment variables
    environment.sessionVariables = {
        WLR_NO_HARDWARE_CURSORS = "1"; # Disables hardware cursors in Wayland.
        NIXOS_OZONE_WL = "1"; # Environment variable specific to Wayland (purpose not clearly specified).
    };

    # Enable XDG portals for desktop integration in Wayland
    xdg.portal.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; # Include GTK portals.

    # User configuration
    users.users.erik = {
        isNormalUser = true; # Specify 'erik' as a regular user.
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
        wget # Utility for non-interactive download of files from the Web.
        git # Distributed version control system.
        neovim # Vim-fork focused on extensibility and usability.
        kitty # A modern, hackable, featureful, OpenGL-based terminal emulator.
        direnv # An environment switcher for the shell.
        firefox # Web browser.
        ntfs3g # NTFS read-write support driver.
        waybar # Highly customizable Wayland bar for Sway and Wlroots based compositors.
        dunst # Lightweight and customizable notification daemon.
        libnotify # Library for sending desktop notifications.
        rofi-wayland # A window switcher, application launcher, and dmenu replacement for Wayland.
        (pkgs.waybar.overrideAttrs (oldAttrs: {
                mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ]; # Custom override for Waybar with experimental features.
            })
        )
        swww # Efficient animated wallpaper daemon for wayland, controlled at runtime
    ];

    # Font configuration
    fonts.fonts = with pkgs; [
        ubuntu_font_family # Ubuntu font family.
        nerdfonts # Nerd Fonts collection.
    ];

    # Console configuration
    console = {
        font = "Lat2-Terminus16"; # Console font.
        keyMap = "us"; # Keyboard layout for the console.
    };

    # Nix Flakes configuration
    nix = {
        package = pkgs.nixFlakes; # Set the Nix package to Nix with Flakes support.
        extraOptions = "experimental-features = nix-command flakes"; # Enable experimental features for Flakes.
    };

    # Environment variables
    environment.variables.MOZ_ENABLE_WAYLAND = "1"; # Enable Wayland support in Firefox.
}