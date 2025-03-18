{ buildJavaTool }:

buildJavaTool {
  pname = "pathweaver";

  name = "PathWeaver";

  artifactHashes = {
    linuxarm32 = "sha256-KOOqcfq1eABxkiDQ7u1rCK578L+2w/s1a49H37XSWmU=";
    linuxarm64 = "sha256-HMxFUuWaytxu2ZDdPmmnNADuwFHS/5MAGPat5I2iCV8=";
    linuxx64 = "sha256-Rdz3wVxFpfcw+7Bp+RzT6Xnhw5dvRrzy+mYZrDFd+hY=";
    macarm64 = "sha256-MjBjx9k473AIkzDbpBVh/a/pUuPbhN3eywQS3BYZoeU=";
    macx64 = "sha256-AgnevTtWCEG+hTpmWe4PqDIsrhYri6B1lmFpdPas2VQ=";
  };

  iconSvg = ./wpilib_logo.svg;

  meta = {
    description = "A trajectory generation suite that for FRC teams to generate and follow trajectories";
  };
}
