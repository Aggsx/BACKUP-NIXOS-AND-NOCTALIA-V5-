{
  description = "Configuración Flake de Axel";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # MangoWM / mangowc
    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Noctalia
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Noctalia Greeter (Oficial)
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Umbriel Wayland Compositor
    umbriel = {
      url = "github:noctalia-dev/umbriel";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NiriMod GUI Configurator
    nirimod = {
      url = "github:srinivasr/nirimod";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # my-lazy-nixos-pkgs
    mlnp = {
      url = "github:mikuri12/my-lazy-nixos-pkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Tu nuevo repositorio personal de paquetes dinámicos
    my-packages = {
      url = "github:Aggsx/My-NixOS-packages-";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Millennium (tema/mod para Steam)
    millennium.url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";
  };

  outputs = {
    self,
    nixpkgs,
    mangowm,
    noctalia,
    noctalia-greeter,
    umbriel,
    nirimod,
    mlnp,
    my-packages,
    millennium,
    ...
  }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = {
        inherit inputs;
      };

      modules = [
        ./configuration.nix

        # Módulos de tus inputs
        noctalia-greeter.nixosModules.default
        umbriel.nixosModules.default
      ];
    };
  };
}
