{ buildBinTool, allwpilibSources }:

buildBinTool {
  pname = "sysid";

  name = "SysId";

  artifactHashes = {
    linuxarm32 = "sha256-cFXEDUhU1b2lgc479UEfardlLMjoHYNnchWuXMU2wNw=";
    linuxarm64 = "sha256-r0GPE2s5bzdo746V2C7/1pUWCLcpt9eq0588Ao7rid0=";
    linuxx86-64 = "sha256-EjsCZa749Rc/hH57nY83jagDXI3iBro8Jt2dEcF/6jg=";
    osxuniversal = "sha256-sbgD6hPd0oADWkZS/4Cv6C7CDpEZfIvJkzub9JzMR7M=";
  };

  iconPng = "${allwpilibSources}/sysid/src/main/native/resources/sysid-512.png";

  meta = {
    description = "A tool for performing system identification on FRC robots";
  };
}
