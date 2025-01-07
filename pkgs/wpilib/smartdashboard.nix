{ buildJavaTool }:

buildJavaTool {
  pname = "smartdashboard";

  name = "SmartDashboard";

  artifactHashes = {
    linuxx64 = "sha256-8rFIsTsvDE+3paLNwbFEZR8NxhpTYd03YjvK7ZJrTKU=";
    macx64 = "sha256-uftL4tQAdZsx/5tcGJqHEselvGHca5a+06IQlQGISGw=";
  };

  iconSvg = ./wpilib_logo.svg;

  meta = {
    description = "A simple and resource-efficient FRC dashboard";
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
