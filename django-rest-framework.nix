{ lib, buildPythonPackage, fetchPypi, django, pytz }:
buildPythonPackage rec {
  pname = "djangorestframework";
  version = "3.13.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c33407ce23acc68eca2a6e46424b008c9c02eceb8cf18581921d0092bc1f2ee";
  };

  doCheck = false;

  propagatedBuildInputs = [ django pytz ];

  meta = with lib; {
    maintainers = with maintainers; [ flomonster ];
    description = "Django Rest Framework";
  };
}
