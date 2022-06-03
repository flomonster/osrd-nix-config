let unstable = import <nixos-unstable> { overlays = [ (import <rust-overlay> ) ]; };

build_railway_utils = ps: (ps.buildPythonPackage {
  name = "railway_utils";
  version = "0.0.19";
  src = unstable.fetchzip {
    url = "https://gitlab.com/api/v4/projects/20981537/packages/pypi/files/cd83ffba7c8bbac0df87c1870c9b6c07b7310d29e1eef60403fc272dbc82cba4/railway_utils-0.0.19.tar.gz";
    hash = "sha256-UVV9w9AVqA94cDsFnvmYLFafDRIMdvRuLYxKjv3FyiA=";
  };
});

make_packages = ps:
    let
       django = ps.django_4.override { withGdal = true; };
       djangorestframework = (ps.callPackage (import ./django-rest-framework.nix) { django = django; });
       djangorestframework-gis = (ps.callPackage (import ./django-rest-framework-gis.nix) { djangorestframework = djangorestframework; });
       geojson-pydantic = (ps.callPackage (import ./geojson-pydantic.nix) { pydantic = ps.pydantic; });
    in [
        django
        ps.black
        ps.celery
        ps.flake8
        ps.intervaltree
        ps.jsonschema
        ps.numpy
        ps.pillow
        ps.progress
        ps.psycopg2
        ps.pyyaml
        ps.requests
        ps.websockets
        (ps.callPackage (import ./django-debug-toolbar.nix) { django = django; })
        (ps.callPackage (import ./kdtree.nix) {})
        (build_railway_utils ps)
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
}
