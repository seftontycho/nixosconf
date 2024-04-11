# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  networking.hostName = "sjtdesktop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "gb";
    xkbVariant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.seftontycho = {
    isNormalUser = true;
    description = "Sefton de Pledge";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "tss" ];
    shell = pkgs.fish;
    packages = with pkgs; [
      spotify
      discord
      tdesktop
      google-chrome
    ];
  };

  # Enable automatic login for the user.
  services.getty.autologinUser = "seftontycho";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
  
  
  # Enable Display Manager
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %a • %h | %F' --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 2;
  boot.initrd.enable = true;
  boot.initrd.systemd.enable = true;
  boot.plymouth = {
    enable = true;
    font = "${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Regular.ttf";
    themePackages = [ pkgs.catppuccin-plymouth ];
    theme = "catppuccin-macchiato";
  };
  
  # Fonts
  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-font-patcher
  ];
  
  programs.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    xwayland.enable = true;
  };
  
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };
  
  # Nix Configuration
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];    
  };
  
  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services.auto-cpufreq.enable = true;

  programs.fish.enable = true;
  programs.thunar.enable = true;

  programs.xfconf.enable = true;

  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];

  programs.file-roller.enable = true;

  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  programs.dconf.enable = true;
  programs.direnv.enable = true;

  security.pam.services.swaylock = {};

  services.flatpak.enable = true;
  
  environment.systemPackages = with pkgs; [
    flatpak
    gnome.gnome-software

    greetd.tuigreet
    waybar
    dunst
    libnotify
    wpaperd
    rofi-wayland

    networkmanagerapplet

    figlet
    
    kitty

    starship
    zoxide

    pavucontrol

    vulkan-tools
    vulkan-loader
       
    numix-icon-theme-circle
    colloid-icon-theme
    catppuccin-gtk
    catppuccin-kvantum
    catppuccin-cursors.macchiatoTeal

    at-spi2-atk
    qt6.qtwayland
    psi-notify
    poweralertd
    swaylock-effects
    swayidle
    playerctl
    psmisc
    grim
    slurp
    imagemagick
    swappy
    ffmpeg_6-full
    wf-recorder
    wl-clipboard
    cliphist
    clipboard-jh
    xdg-utils
    wtype
    wlrctl
    hyprpicker 
    avizo
    wlogout
    gifsicle

    zlib
    gzip
    feh

    git
  ];
  
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Enable Theme
  environment.variables.GTK_THEME = "Catppuccin-Macchiato-Standard-Teal-Dark";
  environment.variables.XCURSOR_THEME = "Catppuccin-Macchiato-Teal";
  environment.variables.XCURSOR_SIZE = "24";
  console = {
    earlySetup = true;
    colors = [
      "24273a"
      "ed8796"
      "a6da95"
      "eed49f"
      "8aadf4"
      "f5bde6"
      "8bd5ca"
      "cad3f5"
      "5b6078"
      "ed8796"
      "a6da95"
      "eed49f"
      "8aadf4"
      "f5bde6"
      "8bd5ca"
      "a5adcb"
    ];
  };

  # Override packages
  nixpkgs.config.packageOverrides = pkgs: {
    colloid-icon-theme = pkgs.colloid-icon-theme.override { colorVariants = ["teal"]; };
    catppuccin-gtk = pkgs.catppuccin-gtk.override {
      accents = [ "teal" ]; # You can specify multiple accents here to output multiple themes 
      size = "standard";
      variant = "macchiato";
    };
    discord = pkgs.discord.override {
      withOpenASAR = true;
      withTTS = true;
    };
  };
  
  
}
