{ buildJavaTool }:

buildJavaTool {
  pname = "pathweaver";

  name = "PathWeaver";

  artifactHashes = {
    linuxarm64 = "sha256-aJM3TaO2qeJ0o+yyXUdTZpq4TjbsnDKaZTwpXmseb6g=";
    macarm64 = "sha256-Neq7K7W0QDJKm/jwy08bVq5vNnLqur8R5diOacLkUkw=";
    linuxarm32 = "sha256-9PtqApUvGXRfAxFKfkCeJStmZ3fUynrpa/lPnOEyY38=";
    linuxx64 = "sha256-ObRHZNZ3G2ueLrxQMgaUh+XkeUXeqs7+12prUMzEnms=";
    macx64 = "sha256-dHV8wbQfnySo3Rm7t+MFDycoHtXnPIG8hDX6B/kz+H4=";
  };

  iconSvg = ./wpilib_logo.svg;

  meta = {
    description = "A trajectory generation suite that for FRC teams to generate and follow trajectories";
  };
}
