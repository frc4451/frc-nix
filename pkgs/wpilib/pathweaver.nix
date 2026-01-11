{ buildJavaTool }:

buildJavaTool {
  pname = "pathweaver";

  name = "PathWeaver";

  artifactHashes = {
    linuxarm32 = "sha256-0Wq4+LRQhKf2hPRP55Ieu6TBnevZg/Islc+YIQ1bx6Q=";
    linuxarm64 = "sha256-53KvfPIeeD5w2IRZCVXf5gKQRCTckRbvygsGSfqhb50=";
    linuxx64 = "sha256-rkfpHRaN0lhLiAWCSZ7bv/LuUfqm5XzfbrgGW06oIWo=";
    macarm64 = "sha256-/P9+xR2y4Fz1dT4p+GtTbocAmGTLl1XlJ4H9ZP9vNfU=";
    macx64 = "sha256-3lerTp+TNPufZqM96KySQpF3eQ8MgPPzNTau669qr2U=";
  };

  iconSvg = ./wpilib_logo.svg;

  meta = {
    description = "A trajectory generation suite that for FRC teams to generate and follow trajectories";
  };
}
