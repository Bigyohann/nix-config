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
      # Function to create a configuration for a specific user and system
      mkHome = system: username: home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [ ./home.nix ];
        extraSpecialArgs = { inherit inputs username system; };
      };
    in
    {
      homeConfigurations = {
        # You define specific targets here
        "bigyohann@macbook-pro" = mkHome "aarch64-darwin" "bigyohann";
        "bigyohann@work-laptop" = mkHome "x86_64-darwin" "bigyohann";
        "bigyohann@linux-server" = mkHome "x86_64-linux" "bigyohann";
      };
    };
}
