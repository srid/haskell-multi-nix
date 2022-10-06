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
          overlay = self: super: {
            # Local packages in the repository
            foo = self.callCabal2nix "foo" ./foo {};
            bar = self.callCabal2nix "bar" ./bar {};
            # TODO: Put any package overrides here
          };
          # Extend the `pkgs.haskellPackages` attrset using an overlay.
          haskellPackages' = pkgs.haskellPackages.extend overlay;
        in {
          packages.foo = haskellPackages'.foo;
          packages.default = haskellPackages'.bar;
        };
    };
}
