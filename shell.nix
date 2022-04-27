let unstable = import <nixos-unstable> { overlays = [ (import <rust-overlay> ) ]; };

build_railway_utils = ps: (ps.buildPythonPackage {
  name = "railway_utils";
  version = "0.0.10";
  src = unstable.fetchzip {
    url = "https://gitlab.com/api/v4/projects/20981537/packages/pypi/files/752594f23f5fcf4a5b1155f246db0333dc6ce75113c79666ed849d4d10d33a99/osrdata_railway_utils-0.0.10.tar.gz";
    hash = "sha256:1fpds1yln4rhbdfh2kakdgz1501pwhrvz3nv7i1ap5k981rmjhrs";
  };
});

make_packages = ps:
    let django = (ps.django_3.override { withGdal = true; }).overrideAttrs (
          oldAttrs: rec {
            version = "4.0.4";
            src = ps.fetchPypi {
              pname = "Django";
              inherit version;
              sha256 = "4e8177858524417563cc0430f29ea249946d831eacb0068a1455686587df40b5";
            };
          }
        );
    djangorestframework = (ps.djangorestframework.override { django = django; });
    djangorestframework-gis = (ps.callPackage (import ./django-rest-framework-gis.nix) { inherit djangorestframework; });
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
    unstable.rustc
    unstable.rustfmt
    unstable.clippy
    unstable.rust-analyzer

    unstable.postgresql
    unstable.openssl
    unstable.pkgconfig
  ];

  RUST_SRC_PATH = "${unstable.rust.packages.stable.rustPlatform.rustLibSrc}";
}
