{ lib, buildPythonPackage, fetchPypi, djangorestframework }:
buildPythonPackage rec {
  pname = "djangorestframework-gis";
  version = "1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "921c5adbc9a7c0502c905957a6695b67f55d7bf6582e1ab837888b55a1fce5a6";
  };

  doCheck = false;

  propagatedBuildInputs = [ djangorestframework ];

  meta = with lib; {
    maintainers = with maintainers; [ multun ];
    description = "Geographic add-ons for Django REST Framework";
  };
}
