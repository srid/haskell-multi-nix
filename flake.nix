{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    haskell-flake.url = "github:srid/haskell-flake";
  };
  outputs = { self, nixpkgs, flake-parts, haskell-flake }:
    flake-parts.lib.mkFlake { inherit self; } {
      systems = nixpkgs.lib.systems.flakeExposed;
      imports = [ haskell-flake.flakeModule ];
      perSystem = { self', inputs', pkgs, system, ... }:
        {
          # Most simple configuration requires only:
          # haskellProjects.default = { };
          haskellProjects.default = {
            # Haskell dependency overrides go here 
            # overrides = self: super: {
            # };
            # hlsCheck = false;
            # hlintCheck = true;
            packages = {
              foo.root = ./foo;
              bar.root = ./bar;
            };
          };
          packages.default = self'.packages.bar;
        };
    };
}
