let stable = import <nixos> { overlays = [ (import <rust-overlay> ) ]; };

make_packages = ps:
    let
       django = ps.django_4.override { withGdal = true; };
       djangorestframework = (ps.callPackage (import ./django-rest-framework.nix) { django = django; });
       djangorestframework-gis = (ps.callPackage (import ./django-rest-framework-gis.nix) { djangorestframework = djangorestframework; });
       geojson-pydantic = (ps.callPackage (import ./geojson-pydantic.nix) { pydantic = ps.pydantic; });
    in [
        django
        ps.black
        ps.flake8
        ps.intervaltree
        ps.numpy
        ps.mock
        ps.pillow
        ps.progress
        ps.psycopg
        ps.psycopg2
        ps.pyyaml
        ps.requests
        ps.websockets
        (ps.callPackage (import ./django-debug-toolbar.nix) { django = django; })
        (ps.callPackage (import ./kdtree.nix) {})
        djangorestframework
        djangorestframework-gis
        geojson-pydantic
        (ps.callPackage (import ./django-cors-headers.nix) { django = django; })
        (ps.callPackage (import ./django-redis.nix) { django = django; redis=ps.redis;})

        # Chartos
        ps.uvicorn
        ps.fastapi
        ps.asyncpg
        ps.aioredis
    ];
in stable.mkShell {
  nativeBuildInputs = [
     stable.rust-bin.nightly.latest.default
  ];

  buildInputs = [
    # API
    (stable.python3.withPackages make_packages)
    # EDITOAST
    stable.cargo
    stable.cargo-watch
    stable.cargo-tarpaulin
    stable.rustc
    stable.rustfmt
    stable.clippy
    stable.rust-analyzer

    stable.postgresql
    stable.openssl
    stable.pkgconfig
  ];

  RUST_SRC_PATH = "${stable.rust.packages.stable.rustPlatform.rustLibSrc}";
  ROCKET_PROFILE = "debug";
  OSRD_DEV = "True";
  OSRD_BACKEND_URL = "http://localhost:8080";
}
