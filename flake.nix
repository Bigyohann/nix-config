{
  description = "Portable Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      supportedSystems = [ "aarch64-darwin" "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      
      mkHome = system: username: home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [ ./home.nix ];
        extraSpecialArgs = { inherit inputs username system; };
      };
    in
    {
      homeConfigurations = {
        "bigyohann@macbook-pro" = mkHome "aarch64-darwin" "bigyohann";
        "bigyohann@nixos" = mkHome "x86_64-linux" "bigyohann";
        "bigyohann" = mkHome "x86_64-linux" "bigyohann";
      };

      # Permet de faire 'nix run .'
      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${home-manager.packages.${system}.home-manager}/bin/home-manager";
        };
      });
    };
}
