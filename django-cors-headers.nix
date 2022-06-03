{ lib, buildPythonPackage, fetchPypi, django, sqlparse, setuptools_scm, redis }:
buildPythonPackage rec {
  pname = "django-cors-headers";
  version = "3.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5f07e2ff8a95c887698e748588a4a0b2ad0ad1b5a292e2d33132f1253e2a97cb";
  };

  doCheck = false;

  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ django sqlparse redis];

  meta = with lib; {
    maintainers = with maintainers; [ flomonster ];
    description = "Django cors headers";
  };
}
