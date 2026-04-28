{
  stdenv,
  autoPatchelfHook,
  fetchurl,
  jre,
  makeWrapper,
  lib,
  libxkbcommon,
  libx11,
  libxtst,
  libxt,
}:
stdenv.mkDerivation rec {
  name = "OpenDS";
  version = "0.3.1";

  src = fetchurl {
    url = "https://github.com/Boomaa23/open-ds/releases/download/v${version}/open-ds-v${version}.jar";
    sha256 = "01d6c0df4e166188cc216326cc453ffcc04c4709ffef55a19cb934c3ab3d9009";
  };
  dontUnpack = true;
  nativeBuildInputs = [makeWrapper autoPatchelfHook jre];
  buildInputs = [libxkbcommon libx11 libxtst libxt];
  installPhase = ''
    mkdir -pv $out/share/java $out/bin

    cp ${src} $out/share/java/${name}-${version}.jar

    jar xf $out/share/java/${name}-${version}.jar


    makeWrapper ${jre}/bin/java $out/bin/OpenDS \
      --add-flags "-Djnativehook.lib.path=/tmp" \
      --add-flags "-jar $out/share/java/${name}-${version}.jar" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [libxkbcommon libx11 libxtst libxt]}

  '';

  meta = {
    homepage = "https://boomaa23.github.io/open-ds";
    description = "An open source version of FRC's DriverStation";
    platforms = lib.platforms.all;
  };
}
