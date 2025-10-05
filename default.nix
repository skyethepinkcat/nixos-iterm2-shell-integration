let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-25.05";
  pkgs = import nixpkgs {
    config = {};
    overlays = [];
  };
in {
  it2shell = pkgs.callPackage ./it2shell.nix {};
}
