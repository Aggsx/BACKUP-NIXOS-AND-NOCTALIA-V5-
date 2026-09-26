{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Aplicar los overlays
  nixpkgs.overlays = [
    inputs.nirimod.overlays.default
    inputs.mlnp.overlays.default
    inputs.my-packages.overlays.default
    inputs.millennium.overlays.default
  ];

  # Niri inestable
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  # Umbriel Wayland Compositor
  programs.umbriel = {
    enable = true;
  };

  # Configuración MANGO
  programs.mango = {
    enable = true;
  };

  # SwayFX (Sway fork con efectos visuales: blur, rounded corners, shadows)
  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
    wrapperFeatures.gtk = true;
  };

  # Bootloader y Kernel
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "preempt=full" ];
  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Red y Localización
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "America/Managua";
  i18n.defaultLocale = "es_MX.UTF-8";

  # Escritorio y Servicios base
  services.xserver.enable = true;
  services.desktopManager.gnome.enable = true;
  services.flatpak.enable = true;
  programs.gpu-screen-recorder.enable = true;

  # Habilitar la infraestructura de virtualización necesaria para GNOME Boxes (Flatpak)
  virtualisation.libvirtd = {
    enable = true;
    qemu.swtpm.enable = true;
  };

  # Habilitar virt-manager mediante su módulo nativo para solucionar el error de conexión
  programs.virt-manager.enable = true;

  # Servicios para Thunar
  services.tumbler.enable = true;
  programs.xfconf.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # OBS Studio
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = false;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi
      obs-vkcapture
      obs-gstreamer
    ];
  };

  # Steam
  programs.steam = {
    enable = true;
    package = pkgs.millennium-steam;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = false;
  };

  # Sunshine
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  programs.gamemode.enable = true;

  # MPD y MPRIS
  services.mpd.enable = false;

  systemd.user.services.mpd = {
    enable = true;
    description = "Music Player Daemon";
    wantedBy = [ "default.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.mpd}/bin/mpd --no-daemon";
    };
  };

  systemd.user.services.mpd-mpris = {
    enable = true;
    description = "MPD MPRIS bridge";
    wantedBy = [ "default.target" ];
    after = [ "mpd.service" ];

    serviceConfig = {
      ExecStart = "${pkgs.mpd-mpris}/bin/mpd-mpris -host 127.0.0.1 -port 6600";
      Restart = "on-failure";
    };
  };

  # Teclado y Sonido
  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };

  console.keyMap = "us-acentos";

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };

  hardware.steam-hardware.enable = true;

  # Usuario y Shell
  users.users.axelnixos = {
    isNormalUser = true;
    description = "Axelnixos";

    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "video"
      "lp"
      "scanner"
      "libvirtd"
    ];
  };

  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set -g fish_greeting ""
    '';
  };

  programs.starship.enable = true;

  programs.bash.interactiveShellInit = ''
    if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
    then
      shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
      exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
    fi
  '';

  # Portales XDG
  xdg.portal = {
    enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];

    config.common.default = [ "gtk" ];
    config.niri.default = [ "gnome" "gtk" ];
  };

  # Integración Nix-Alien y Nix-LD
  programs.nix-ld.enable = true;

  # Paquetes del Sistema
  nixpkgs.config = {
    allowUnfree = true;
  };

  environment.localBinInPath = true;

  environment.systemPackages = with pkgs; [
    fuzzel
    xwayland-satellite
    gpu-screen-recorder-gtk
    gpu-screen-recorder
    kitty
    ghostty
    thunar
    wlr-randr
    yazi
    fastfetch
    fish
    ffmpeg
    cava
    mpd
    mpc
    rmpc
    mpd-mpris
    grim
    slurp
    libnotify
    wl-clipboard
    mpv
    loupe
    gnome-software
    flatpak
    jq
    brightnessctl
    btop
    tty-clock
    nano
    cozette
    nerd-fonts.symbols-only
    starship
    thunar-archive-plugin
    thunar-volman
    thunar-media-tags-plugin
    thunar-vcs-plugin
    thunar-volman
    thunar-media-tags-plugin
    atool
    adw-gtk3
    qt6Packages.qt6ct
    kdePackages.qtwayland
    kdePackages.qqc2-desktop-style
    unzip
    git
    ffmpegthumbnailer
    poppler_gi
    corefonts
    onlyoffice-desktopeditors
    unrar
    nwg-look
    p7zip
    evtest
    inputs.noctalia.packages.${pkgs.system}.default
    nirimod
    obsidian
    pkgs.opencode
    pkgs.faugus-launcher
    nitch
    lavat
    foot
    helium
    pkgs.librewolf-bin
    jopdf
    pkgs.gnome-boxes
    lutgen
    gnutar
    pkgs.matugen
    pkgs.smem
    pkgs.pcmanfm
    pkgs.qbittorrent
    pkgs.opencode-desktop
    htop
    pkgs.microfetch
    vesktop
    pkgs.gearlever
    pkgs.chafa
    pkgs.sunshine
  ];

  environment.sessionVariables = {
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_QPA_PLATFORMTHEME = "qt6ct";
    NIXOS_OZONE_WL = "1";
    EDITOR = "nano";

    XDG_DATA_DIRS = [
      "/run/current-system/sw/share"
      "/home/axelnixos/.nix-profile/share"
      "/var/lib/flatpak/exports/share"
      "/home/axelnixos/.local/share/flatpak/exports/share"
    ];
  };

  programs.dconf.enable = true;

  system.stateVersion = "25.11";

  systemd.user.services.ibus-daemon.enable = false;

  i18n.inputMethod.enable = false;

  i18n.extraLocaleSettings = {
    LC_TIME = "en_US.UTF-8";
  };

  # Módulo oficial de Noctalia Greeter
  programs.noctalia-greeter = {
    enable = true;

    settings = {
      keyboard = {
        layout = "us";
        variant = "intl";
      };
    };
  };
}
