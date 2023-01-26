{ lib, buildPythonPackage, fetchPypi, djangorestframework }:
buildPythonPackage rec {
  pname = "drf-nested-routers";
  version = "0.93.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01aa556b8c08608bb74fb34f6ca065a5183f2cda4dc0478192cc17a2581d71b0";
  };

  doCheck = false;

  propagatedBuildInputs = [ djangorestframework ];

  meta = with lib; {
    maintainers = with maintainers; [ flomonster ];
    description = "Django Rest Framework Nested Routers";
  };
}
