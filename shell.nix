let stable = import <nixos> { overlays = [ (import <rust-overlay> ) ]; };

make_packages = ps:
    let
       django = ps.django_4.override { withGdal = true; };
       djangorestframework = (ps.callPackage (import ./django-rest-framework.nix) { django = django; });
       djangorestframework-gis = (ps.callPackage (import ./django-rest-framework-gis.nix) { djangorestframework = djangorestframework; });
       drf-nested-routers = (ps.callPackage (import ./drf-nested-routers.nix) { djangorestframework = djangorestframework; });
       geojson-pydantic = (ps.callPackage (import ./geojson-pydantic.nix) { pydantic = ps.pydantic; });
    in [
        django
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
        (ps.callPackage (import ./django-debug-toolbar.nix) { django = django; })
        (ps.callPackage (import ./kdtree.nix) {})
        djangorestframework
        djangorestframework-gis
        drf-nested-routers
        geojson-pydantic
        (ps.callPackage (import ./django-cors-headers.nix) { django = django; })
        (ps.callPackage (import ./django-redis.nix) { django = django; redis=ps.redis;})

        # Chartos
        ps.uvicorn
        ps.fastapi
        ps.asyncpg
        ps.aioredis

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
     stable.rust-bin.nightly.latest.default
     # stable.rust-bin.stable.latest.default
  ];

  buildInputs = [
    # API
    (stable.python310.withPackages make_packages)
    # EDITOAST
    stable.cargo
    stable.cargo-watch
    stable.cargo-tarpaulin
    stable.rustc
    stable.rustfmt
    stable.clippy
    stable.rust-analyzer
    stable.osmium-tool
    stable.rPackages.libgeos
    stable.openssl
    stable.pkgconfig
    stable.postgresql
  ];

  RUST_SRC_PATH = "${stable.rust.packages.stable.rustPlatform.rustLibSrc}";
  ROCKET_PROFILE = "debug";
  OSRD_DEV = "True";
  OSRD_BACKEND_URL = "http://localhost:8080";
}
