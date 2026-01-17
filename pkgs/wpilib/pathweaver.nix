{ buildJavaTool }:

buildJavaTool {
  pname = "pathweaver";

  name = "PathWeaver";

  artifactHashes = {
    linuxarm32 = "sha256-rwSz811g2NhLqPbvH1SJ4tLMzb4Xr7ulSHQZfZBIh30=";
    linuxarm64 = "sha256-2CjhcnOnIgSJdSfgRQLfVyfenFe84MtRXrN7ciA8gS8=";
    linuxx64 = "sha256-aRoNA7fclF696WiVhvMf8NGBbnSzGheQlk4V7e3v810=";
    macarm64 = "sha256-CYa/pEyCX1STmjAkazPNuhBJbFW+9wu2Nj6lboaYIZc=";
    macx64 = "sha256-2lz2w7+HOyUE/wIbw/HUwuvN0rHmdBVs1uRyNrGmr4I=";
  };

  iconSvg = ./wpilib_logo.svg;

  meta = {
    description = "A trajectory generation suite that for FRC teams to generate and follow trajectories";
  };
}
