{ lib, buildPythonPackage, fetchPypi, djangorestframework }:
buildPythonPackage rec {
  pname = "djangorestframework-gis";
  version = "0.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6ddd201a208e68f8f11ac71d2df2c030b1280818a4b54681be00e73057fcafb1";
  };

  doCheck = false;

  propagatedBuildInputs = [ djangorestframework ];

  meta = with lib; {
    maintainers = with maintainers; [ multun ];
    description = "Geographic add-ons for Django REST Framework";
  };
}
