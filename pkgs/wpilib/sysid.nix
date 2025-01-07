{ buildBinTool, allwpilibSources }:

buildBinTool {
  pname = "sysid";

  name = "SysId";

  artifactHashes = {
    linuxarm32 = "sha256-mC+6YN/L6TRvFedw9MJNG43fMQntlba1IjIIReWZIyY=";
    linuxarm64 = "sha256-tWhyGTRyK2tV0gEEHD057l8UufTMSDwtizEg04nyUsk=";
    linuxx86-64 = "sha256-fzRydw4SgSg7WoP0a85tqpDGnOZtRkR4BRddMKTQtFs=";
    osxuniversal = "sha256-rChA9oaBRlq8tDtLyFkNYggDNuI6mJopLqKGeWYCz8E=";
  };

  iconPng = "${allwpilibSources}/sysid/src/main/native/resources/sysid-512.png";

  meta = {
    description = "A tool for performing system identification on FRC robots";
  };
}
