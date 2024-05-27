{
  inputs = {
    nixos.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = { self, nixos }: {
    nixosConfigurations.default = nixos.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ config, pkgs, lib, ... }: {
          services.kmscon = {
            enable = true;
            autologinUser = "root";
            extraOptions = "--debug";
          };
          system.stateVersion = "23.11";
          virtualisation.vmVariant.virtualisation = {
            memorySize = 300;
            cores = 1;
            graphics = true;
          };
        })
      ];
    };
    apps.x86_64-linux.default = {
      type = "app";
      program = "${self.nixosConfigurations.default.config.system.build.vm}/bin/run-nixos-vm";
    };
  };
}
