{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs.follows = "nixpkgs";
    haskell-flake.url = "github:HariAmoor-professional/haskell-flake/issue-7";
  };
  outputs = { self, nixpkgs, flake-parts, haskell-flake }:
    flake-parts.lib.mkFlake { inherit self; } {
      systems = nixpkgs.lib.systems.flakeExposed;
      imports = [ haskell-flake.flakeModule ];
      perSystem = { self', inputs', pkgs, system, ... }:
        {
          haskellProjects.default = {
            haskellPackages = pkgs.haskell.packages.ghc924;
            root = ./.;
            overrides = _: _: { };
            buildTools = { };
            hlsCheck = false;
            hlintCheck = true;

            packages.default = self'.packages.foo;
            apps.default = self'.packages.bar;
          };
        };
    };
}
