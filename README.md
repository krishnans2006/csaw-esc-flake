# CSAW ESC Flake

A Nix flake for CSAW ESC (Embedded Security Challenge).

Installs:
- Custom derivations for the `chipwhisperer` and `logic2-automation` Python packages
- Jupyter Notebook support

Requires:
- System-wide installation of the `saleae-logic-2` package (The actual analyzer that the Python package communicates with)
