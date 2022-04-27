{ lib, buildPythonPackage, fetchPypi, django, sqlparse, setuptools_scm, redis }:
buildPythonPackage rec {
  pname = "django-cors-headers";
  version = "3.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0y1gcl98brp2lb9107jm8png34f10z4l076w970njr94ymh46vyd";
  };

  doCheck = false;

  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ django sqlparse redis];

  meta = with lib; {
    maintainers = with maintainers; [ flomonster ];
    description = "Django cors headers";
  };
}
