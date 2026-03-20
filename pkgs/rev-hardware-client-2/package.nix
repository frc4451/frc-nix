{
  lib,
  stdenvNoCC,
  makeWrapper,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rev-hardware-client-2";
  version = "1.0.7";

  src = fetchTarball {
    url = "https://rhc2.revrobotics.com/download/rev-hardware-client-1.0.7-linux-amd64.tar.gz";

  };

  nativeBuildInputs = [
    makeWrapper
  ];

  # buildInputs = [
  #
  # ];

  meta = {
    description = "Hardware client for REV devices.";
    homepage = "";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ ];
  };
})
