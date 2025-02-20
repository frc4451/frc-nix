{ buildJavaTool }:

buildJavaTool {
  pname = "smartdashboard";

  name = "SmartDashboard";

  artifactHashes = {
    linuxx64 = "sha256-Q2YqppAbTaZSCBYpOJp3soPiywI0oKdB5+DIYYPoNRI=";
    macx64 = "sha256-LOL2pED6zP3weK32I8Es6ZgpJbajP5cbcNxpqJRqhS8=";
  };

  iconSvg = ./wpilib_logo.svg;

  meta = {
    description = "A simple and resource-efficient FRC dashboard";
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
