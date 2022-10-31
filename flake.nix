{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs.follows = "nixpkgs";
    haskell-flake.url = "path:/home/hariamoor/platonic-systems/haskell-flake";
  };
  outputs = { self, nixpkgs, flake-parts, haskell-flake }:
    flake-parts.lib.mkFlake { inherit self; } {
      systems = nixpkgs.lib.systems.flakeExposed;
      imports = [ haskell-flake.flakeModule ];
      perSystem = { self', inputs', pkgs, system, ... }:
        {
          haskellProjects.default = {
            overrides = _: _: { };
            hlsCheck = false;
            hlintCheck = true;
            packages = { foo = { root = ./foo; }; bar = { root = ./bar; }; };
          };
          packages.default = self'.packages.bar;
        };
    };
}
