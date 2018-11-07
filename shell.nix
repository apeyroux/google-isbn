{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, aeson, base, bytestring, conduit
      , conduit-extra, hpack, http-conduit, stdenv, text
      }:
      mkDerivation {
        pname = "google-isbn";
        version = "0.0.0";
        src = ./.;
        libraryHaskellDepends = [
          aeson base bytestring conduit conduit-extra http-conduit text
        ];
        libraryToolDepends = [ hpack ];
        preConfigure = "hpack";
        license = stdenv.lib.licenses.unfree;
        hydraPlatforms = stdenv.lib.platforms.none;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant (haskellPackages.callPackage f {});

in

  if pkgs.lib.inNixShell then drv.env else drv
