# haskell-multi-nix

Just a simple demo of Nixifying a *multi-package* Haskell project.

## Packages

This project has two local Haskell packages:

1. `foo`: a Haskell library exporting `Foo.fooFunc`.
2. `bar`: a Haskell executable that depends on `foo`

To build the `foo` library:

```sh
nix build .#foo
```

To build the `bar` executable:

```sh
nix build
```

To run the executable:

```sh
nix run
```

## Dev Shell

The Nix development shell (`nix develop`) allows you to run the various `cabal` commands on the local packages.

For example, this will compile and run the main executable:

```sh
nix develop -c cabal -- run bar
```

## Explanation

The Haskell infrastructure in nixpkgs provides a package set (an attrset) called `pkgs.haskellPackages`[^ver]. We add two more packages -- `foo` and `bar` (the local packages) -- to this package set. We do this by using the standard nixpkgs overlay API (specifically `extend`, which was created by the implicit `makeExtensible`) defined in [fixed-points.nix](https://github.com/NixOS/nixpkgs/blob/master/lib/fixed-points.nix). After having added the local packages, the result is a *new* package set, which is no different *in essense* to the original package set (we can also put our dependency overrides in the same, or different, overlay). Note that any package in a package set can depend on any other packages; thus, it becomes possible to make `bar` depend on `foo` (see "build-depends" in `./bar/bar.cabal`) even though they come from the same overlay.

[^ver]: The package set `pkgs.haskellPackages` corresponds to the default GHC version. Non-default GHC versions have their own package sets, for e.g.: `pkgs.haskell.packages.ghc924` is the package set for GHC 9.2.4.
