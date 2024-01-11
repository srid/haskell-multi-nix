{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    haskell-flake.url = "github:srid/haskell-flake";
  };
  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;
      imports = [ inputs.haskell-flake.flakeModule ];
      perSystem = { self', inputs', pkgs, system, ... }: {
        haskellProjects.default = {
          debug = true;
          # Want to override dependencies?
          # See https://haskell.flake.page/dependency
        };
        packages.default = self'.packages.bar;
      };
    };
}
