{ buildJavaTool }:

buildJavaTool {
  pname = "pathweaver";

  name = "PathWeaver";

  artifactHashes = {
    linuxarm32 = "sha256-tU/iEh9yujt7wFONXd653Bdw6vsEycYB0IRKNI5NJNs=";
    linuxarm64 = "sha256-fTR10SPG6sIn25pMUleT3hl7B7n/qwCWzb4pqK0Gt4Q=";
    linuxx64 = "sha256-HNweJjTROLU6m0gSSW6zVwCIY/fW7nyOmQJmZNGrBkA=";
    macarm64 = "sha256-z4g1T0ySyPQ2yCotmiFo5s2maDvrjEDHc+irMR3dJB8=";
    macx64 = "sha256-bTWYntsnXI+PjyzFukFuL5skNIgUy5xg7FdquQqcm9k=";
  };

  iconSvg = ./wpilib_logo.svg;

  meta = {
    description = "A trajectory generation suite that for FRC teams to generate and follow trajectories";
  };
}
