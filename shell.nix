let stable = import <nixos> { overlays = [ (import <rust-overlay> ) ]; };

make_packages = ps:
    let
       geojson-pydantic = (ps.callPackage (import ./geojson-pydantic.nix) { pydantic = ps.pydantic; });
    in [
        ps.black
        ps.isort
        ps.flake8
        ps.intervaltree
        ps.numpy
        ps.mock
        ps.pillow
        ps.psycopg
        ps.psycopg2
        ps.pyyaml
        ps.requests
        ps.websockets
        (ps.callPackage (import ./kdtree.nix) {})
        geojson-pydantic

        # DATA SCIENCE LOL
        ps.ipykernel ps.jupyterlab
        ps.shapely ps.pyproj
        ps.ipympl ps.matplotlib
        ps.networkx
        ps.pyosmium

        ps.progress
        ps.tqdm
        ps.ipywidgets
    ];
in stable.mkShell {
  nativeBuildInputs = [
     # stable.rust-bin.nightly.latest.default
     stable.rust-bin.stable.latest.default
  ];

  buildInputs = [
    # API
    (stable.python310.withPackages make_packages)
    stable.poetry
    # EDITOAST
    stable.cargo
    stable.cargo-watch
    stable.cargo-tarpaulin
    stable.rustc
    stable.rustfmt
    stable.clippy
    stable.rust-analyzer
    stable.osmium-tool
    stable.geos
    stable.openssl
    stable.pkgconfig
    stable.postgresql
  ];

  RUST_SRC_PATH = "${stable.rust.packages.stable.rustPlatform.rustLibSrc}";
  ROCKET_PROFILE = "debug";
  OSRD_DEV = "True";
  OSRD_BACKEND_URL = "http://localhost:8080";
}
