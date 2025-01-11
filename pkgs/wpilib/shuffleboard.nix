{ buildJavaTool }:

buildJavaTool {
  pname = "shuffleboard";

  name = "Shuffleboard";

  artifactHashes = {
    linuxarm32 = "sha256-reDsjquo7oHT2HdJwEldJSrrH8Afb+DUcFepWcSdYNw=";
    linuxarm64 = "sha256-Fa2cZB1GNUt92rKuk3/7WaPK/QaNCSoDSHSaQa7YxBs=";
    linuxx64 = "sha256-l/rX8XiPdZgChON2/n/L+PgmvWLqolC5TWmmPRPV3Xc=";
    macarm64 = "sha256-sCseY/lLUcbKiEF3FYyjfOUDQpysC0Mfcenu7gjpQ14=";
    macx64 = "sha256-VPWnHldcMN1AVrZ2L3j5FW0DhDCBIMtND0qEPzZLNxE=";
  };

  iconSvg = ./wpilib_logo.svg;

  meta = {
    description = "A straightforward, customizable driveteam-focused dashboard for FRC";
  };
}
