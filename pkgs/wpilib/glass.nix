{ buildBinTool, allwpilibSources }:

buildBinTool {
  pname = "glass";

  name = "Glass";

  artifactHashes = {
    linuxarm32 = "sha256-17NzKnNrZih/IVQXGU9CnT62kRJU/kbm951McCMULnc=";
    linuxarm64 = "sha256-eYeEhefrAtgEBH8zhQj6MpimtBa/N5b7cXtCR/7UoTU=";
    linuxx86-64 = "sha256-Syn4+cvWnPwcdTUA4Q3/dmfLBPdf5PqraEAAeEKl9XA=";
    osxuniversal = "sha256-rYwDXSF+Qcp0j6Neg0aayjkY7vl7Qfyb24YVeux9X6w=";
  };

  iconPng = "${allwpilibSources}/glass/src/app/native/resources/glass-512.png";

  meta = {
    description = "A dashboard and data visualization tool for FRC robots";
  };
}
