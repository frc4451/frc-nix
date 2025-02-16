{ buildJavaTool }:

buildJavaTool {
  pname = "smartdashboard";

  name = "SmartDashboard";

  artifactHashes = {
    macx64 = "sha256-LOL2pED6zP3weK32I8Es6ZgpJbajP5cbcNxpqJRqhS8=";
    winx64 = "sha256-SCmHqOUKqJp64MnGweqJmuo0ldwDsFWDH3f5mqD8zMQ=";
    linuxx64 = "sha256-Q2YqppAbTaZSCBYpOJp3soPiywI0oKdB5+DIYYPoNRI=";
  };

  iconSvg = ./wpilib_logo.svg;

  meta = {
    description = "A simple and resource-efficient FRC dashboard";
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
