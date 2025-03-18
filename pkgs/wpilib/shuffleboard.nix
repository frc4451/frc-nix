{ buildJavaTool }:

buildJavaTool {
  pname = "shuffleboard";

  name = "Shuffleboard";

  artifactHashes = {
    linuxarm32 = "sha256-kICubqC0ks7s40D/vuf7bqXmHBmRNrmaioCwSHsMHhQ=";
    linuxarm64 = "sha256-5370NBC2Lx5BXH6Y8WjmeRI+UfpKhu1mn0l6EJp8xhA=";
    linuxx64 = "sha256-WO8jGCemjDHrRaw+zhfSM/p4uEEsNdqb+RLBmgFMdpg=";
    macarm64 = "sha256-agsSEY74ApZA/lbaCBUWrDSqt/lbl1MocgFiGXZPcJw=";
    macx64 = "sha256-s/I8M+6yUDMNvc0ZlatJP1yCeidsdM+GK0gjxCq8umw=";
  };

  iconSvg = ./wpilib_logo.svg;

  meta = {
    description = "A straightforward, customizable driveteam-focused dashboard for FRC";
  };
}
