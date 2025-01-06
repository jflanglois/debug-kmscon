{
  inputs = {
    nixos.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = { self, nixos }: {
    nixosConfigurations.default = nixos.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ config, pkgs, lib, ... }: {
          nixpkgs.overlays = [
            (final: prev: {
              kmscon = prev.kmscon.overrideAttrs (old: {
                patches = old.patches ++ [
                  (pkgs.fetchpatch {
                    name = "0002-fix-sigchld.patch";
                    url = "https://github.com/Aetf/kmscon/commit/a28e134de089447d9c78f2054db4f0be18878669.patch";
                    sha256 = "sha256-uXjI4hhf42YvhqsA9LJLzbe0goHjcKJrITtux9dq6jg=";
                  })
                ];
              });
            })
          ];
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
