{
  stdenv,
  fetchFromGitHub,
  jre,
  makeWrapper,
  lib,
}:
stdenv.mkDerivation rec {
  name = "OpenDS";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "Boomaa23";
    repo = "open-ds";
    rev = "v${version}";
    hash = "sha256-01d6c0df4e166188cc216326cc453ffcc04c4709ffef55a19cb934c3ab3d9009";
  };
  dontUnpack = true;
  nativeBuildInputs = [makeWrapper];

  installPhase = ''
    mkdir -pv $out/share/java $out/bin
    cp ${src} $out/share/java/${name}-${version}.jar

    makeWrapper ${jre}/bin/java $out/bin/OpenDS \
      --add-flags "-jar $out/share/java/${name}-${version}.jar" \
      --set _JAVA_OPTIONS '-Dawt.useSystemAAFontSettings=on' \
      --set _JAVA_AWT_WM_NONREPARENTING 1
  '';

  # Some easy metadata, in case I forget.
  meta = {
    homepage = "https://boomaa23.github.io/open-ds";
    description = "An open source version of FRC's DriverStation";
    platforms = lib.platforms.all;
  };
}
