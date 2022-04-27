{ lib, buildPythonPackage, fetchPypi, django, redis  }:
buildPythonPackage rec {
  pname = "django-redis";
  version = "5.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8a99e5582c79f894168f5865c52bd921213253b7fd64d16733ae4591564465de";
  };

  doCheck = false;

  propagatedBuildInputs = [ django redis ];

  meta = with lib; {
    maintainers = with maintainers; [ flomonster ];
    description = "Django redis";
  };
}
