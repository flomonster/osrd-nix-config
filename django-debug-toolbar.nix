{ lib, buildPythonPackage, fetchPypi, django, sqlparse, setuptools_scm }:
buildPythonPackage rec {
  pname = "django-debug-toolbar";
  version = "3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lk134s0gd7ymq2rikkxg3xqw23wnj0g7b52y0fmgg8dj1yn1ql4";
  };

  doCheck = false;

  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ django sqlparse ];

  meta = with lib; {
    maintainers = with maintainers; [ multun ];
    description = "A Django debug toolbar";
  };
}
