{ buildJavaTool }:

buildJavaTool {
  pname = "shuffleboard";

  name = "Shuffleboard";

  artifactHashes = {
    linuxarm32 = "sha256-ZZV/eaTznuJ+USu3VQFITjIu9c/kbqQd8v5HvRLzB2I=";
    linuxarm64 = "sha256-chjg/eitpoULEV2iYTfQYK9+lP2lDTK0kJNO6UROX4Y=";
    linuxx64 = "sha256-/Fw02QcAlTysAW9FmfBXYsm3WMn8hUnPKQz9TmqC8mw=";
    macarm64 = "sha256-UkcU63mKNC9MVzLToMRsiPMvv6Z3EfMokaScC9jU234=";
    macx64 = "sha256-2wmNY/zpw5pMoXHQcEe1icNz4doKJEhIKlXUZCQ87Wk=";
  };

  iconSvg = ./wpilib_logo.svg;

  meta = {
    description = "A straightforward, customizable driveteam-focused dashboard for FRC";
  };
}
