{ buildBinTool, allwpilibSources }:

buildBinTool {
  pname = "outlineviewer";

  name = "OutlineViewer";

  artifactHashes = {
    linuxarm32 = "sha256-3bxu1I+LlVJL7Km+fZeSTdmZeUMXQzmP3vYFzfy2kPw=";
    linuxarm64 = "sha256-xDhJQsEAL+kDIHxfKAAtZdqWh9YJHzUlqibyO/W+aHw=";
    linuxx86-64 = "sha256-CR8cpFQ7WBfEu6EbOND9YFLGQxtsSJTdmQMzFCSdp8g=";
    osxuniversal = "sha256-+fw20gsEt2/ogcCw8IuLReucCRisvQckl4DtEI8eBs4=";
  };

  iconPng = "${allwpilibSources}/outlineviewer/src/main/native/resources/ov-512.png";

  meta = {
    description = "A utility used to view, modify and add to the contents of NetworkTables";
  };
}
