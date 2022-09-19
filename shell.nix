let unstable = import <nixos-unstable> { overlays = [ (import <rust-overlay> ) ]; };

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
    ];
in unstable.mkShell {
  nativeBuildInputs = [
    unstable.rust-bin.nightly.latest.default
  ];

  buildInputs = [
    # API
    (unstable.python3.withPackages make_packages)
    # EDITOAST
    unstable.cargo
    unstable.cargo-watch
    unstable.cargo-tarpaulin
    unstable.rustc
    unstable.rustfmt
    unstable.clippy
    unstable.rust-analyzer

    unstable.postgresql
    unstable.openssl
    unstable.pkgconfig
  ];

  RUST_SRC_PATH = "${unstable.rust.packages.stable.rustPlatform.rustLibSrc}";
  RUST_TEST_THREADS = "2";
  ROCKET_ENV = "dev";
  OSRD_DEV = "True";
  OSRD_BACKEND_URL = "http://localhost:8080";
}
