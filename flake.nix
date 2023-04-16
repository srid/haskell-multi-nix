{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    haskell-flake.url = "github:sbh69840/haskell-flake/poc-localapps";
  };
  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;
      imports = [ inputs.haskell-flake.flakeModule ];
      perSystem = { self', inputs', pkgs, system, ... }: {
        haskellProjects.default = {
          packages = {
            foo.root = ./foo;
            bar.root = ./bar;
          };
          # Want to override dependencies?
          # See https://haskell.flake.page/dependency
        };
        apps.default = self'.apps.bar;
      };
    };
}
