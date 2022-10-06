{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, flake-parts }:
    flake-parts.lib.mkFlake { inherit self; } {
      systems = nixpkgs.lib.systems.flakeExposed;
      perSystem = {self', inputs', pkgs, system, ... }:
        let
          haskellPackages' = pkgs.haskellPackages.extend (self: super: {
            foo = self.callCabal2nix "foo" ./foo {};
          });
        in {
          packages.foo = haskellPackages'.foo;
        };
    };
}
