{ buildBinTool, allwpilibSources }:

buildBinTool {
  pname = "glass";

  name = "Glass";

  artifactHashes = {
    linuxarm32 = "sha256-JLNucSwiAtLCV+IXKchx9PVkYEEMLgnLMlvD9YoCDe0=";
    linuxarm64 = "sha256-T3Pc4NWK7rTN5V0hobUqq2c1lxxACai3vcWLWMHV/ME=";
    linuxx86-64 = "sha256-WSaCCcQlKoJ8prNLqNUlBZhIOvpynUzwV6CYNtameJw=";
    osxuniversal = "sha256-cXP40rpfDtQPsDFrdtBB7d9YfxywCol6ec9ccJZgkt0=";
  };

  iconPng = "${allwpilibSources}/glass/src/app/native/resources/glass-512.png";

  meta = {
    description = "A dashboard and data visualization tool for FRC robots";
  };
}
