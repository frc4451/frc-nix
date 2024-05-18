{ buildJavaTool }:

buildJavaTool {
  pname = "shuffleboard";

  name = "Shuffleboard";

  artifactHashes = {
    linuxarm32 = "sha256-Ne8EbJ8QVazyLEtJe3VE5enYcuzLISEmUwAWhjkZqlU=";
    linuxarm64 = "sha256-DiNvWeOF0HzEAMbb1DeYR8eGtmH+5ATxDPnvACPSWwQ=";
    linuxx64 = "sha256-9o557w/jqztS2cSq9aBbUS54TGRikn6XAGfJPtfBGzE=";
    macarm64 = "sha256-S6XjUaBp91Da09R03mBMrs7/DSRXfmUin/MQP6yyX38=";
    macx64 = "sha256-IOKISk8Z1PZo/m2teBVV7kRUVslCOn11Di3TH7wGC8g=";
  };

  iconSvg = ./wpilib_logo.svg;

  meta = {
    description = "A straightforward, customizable driveteam-focused dashboard for FRC";
  };
}
