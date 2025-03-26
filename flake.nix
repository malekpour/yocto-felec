{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        devShell = pkgs.mkShellNoCC {
          buildInputs = with pkgs; [
            python3

            binutils
            chrpath
            gcc
            diffstat
            zstd
            rpcsvc-proto
            lz4
          ];

          shellHook = ''
            export PS1="[⚡ Yocto-Felec] \u@\h:\w\$ "
            cd ../..
            
            export HOSTTOOLS_DIR=$PWD/build/.hosttools
            export PATH=$HOSTTOOLS_DIR:$PATH
            mkdir -p $HOSTTOOLS_DIR
            ln -sf $(command -v lz4) $HOSTTOOLS_DIR/lz4c
            
            source ./oe-init-build-env
          '';
        };
      }
    );
}
