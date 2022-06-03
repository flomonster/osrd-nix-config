{ lib, buildPythonPackage, fetchPypi, django, sqlparse, setuptools_scm }:
buildPythonPackage rec {
  pname = "django-debug-toolbar";
  version = "3.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ae6bec2c1ce0e6900b0ab0443e1427eb233d8e6f57a84a0b2705eeecb8874e22";
  };

  doCheck = false;

  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ django sqlparse ];

  meta = with lib; {
    maintainers = with maintainers; [ multun ];
    description = "A Django debug toolbar";
  };
}
