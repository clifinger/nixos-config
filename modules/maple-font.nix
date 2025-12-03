{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "maple-font";
  version = "7.0-beta30";

  src = fetchzip {
    url = "https://github.com/subframe7536/maple-font/releases/download/v${version}/MapleMono-NF.zip";
    hash = "sha256-Rxm7BgeHLKRe4IX5kd74xAfh9U5GrPZHVhucGXJBkF0=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    description = "Open source monospace font with round corner and ligatures";
    homepage = "https://github.com/subframe7536/maple-font";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
