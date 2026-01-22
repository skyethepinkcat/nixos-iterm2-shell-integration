{
  description = "NixOS module for iTerm2 shell integration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Stable NixOS users can override this input in their flake:
    # inputs.nixos-iterm2-shell-integration.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    {
      # NixOS module for all systems
      nixosModules.default = import ./default.nix;
      nixosModules.iterm2-shell-integration = import ./default.nix;

      # nix-darwin module for macOS
      darwinModules.default = import ./default.nix;
      darwinModules.iterm2-shell-integration = import ./default.nix;
    }
    // flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        # Development shell
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            nil
            alejandra
          ];
        };
      }
    );
}
