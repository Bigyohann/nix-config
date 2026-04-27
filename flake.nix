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
      mkHome = system: username: home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [ ./home.nix ];
        extraSpecialArgs = { inherit inputs username system; };
      };
    in
    {
      homeConfigurations = {
        # macOS (Apple Silicon)
        "bigyohann@macbook-pro" = mkHome "aarch64-darwin" "bigyohann";
        
        # NixOS / Generic Linux (x86_64)
        "bigyohann@nixos" = mkHome "x86_64-linux" "bigyohann";
        
        # Default fallback for your current NixOS shell
        "bigyohann" = mkHome "x86_64-linux" "bigyohann";
      };
    };
}
