{
  description = "A Nix flake development environment for CSAW ESC";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: let
        chipwhisperer = pkgs.python312Packages.buildPythonPackage rec {
          pname = "chipwhisperer";
          version = "5.7.0";
          src = pkgs.fetchPypi {
            inherit pname;
            inherit version;
            sha256 = "sha256-xTRUkdo09xKIEGITmEEHSVBd7cqrtD72lR/kklSt7Z8=";
          };
          pyproject = true;
          build-system = [ pkgs.python312Packages.setuptools ];
          propagatedBuildInputs = with pkgs.python312Packages; [
            configobj
            tqdm
            numpy
            fastdtw
            pyserial
            libusb1
            ecpy
            cython
          ];
        };

        logic2-automation = pkgs.python312Packages.buildPythonPackage rec {
          pname = "logic2_automation";
          version = "1.0.7";
          src = pkgs.fetchPypi {
            inherit pname;
            inherit version;
            sha256 = "sha256-9N5nuL/6VnVBM+r2F1sAyOGgeEizi+efX9fsmeBsxyg=";
          };
          pyproject = true;
          build-system = [ pkgs.python312Packages.hatchling ];
          propagatedBuildInputs = with pkgs.python312Packages; [
            grpcio
            grpcio-tools
            protobuf
          ];
        };
      in {
        default = pkgs.mkShell {
          venvDir = ".venv";
          packages = with pkgs; [
            # We assume that Logic 2 is installed system-wide (it needs udev rules anyways, so this isn't a major assumption)
            # See https://github.com/krishnans2006/nixos-config/blob/bea1901b272631e7a409a4a1e5d9cfc59b107fef/modules/packages.nix

            # saleae-logic-2

            python312
            python312Packages.pip
            python312Packages.venvShellHook

            python312Packages.ipython
            python312Packages.jupyter
            python312Packages.notebook
            python312Packages.nbformat
            python312Packages.numpy
            python312Packages.pandas
            python312Packages.tqdm
            python312Packages.matplotlib

            chipwhisperer
            logic2-automation
          ];
        };
      });
    };
}
