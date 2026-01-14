# This derivation is based on https://github.com/NixOS/nixpkgs/blob/master/pkgs/misc/cups/drivers/brother/dcp9020cdw/default.nix
# IMPORTANT: It requires manually linking lpr's /opt/brother/Printers/dcpj100/inf to system's /opt/brother/Printers/dcpj100/inf
{
  lib,
  pkgsi686Linux,
  stdenv,
  fetchurl,
  cups,
  dpkg,
  gnused,
  makeWrapper,
  ghostscript,
  file,
  a2ps,
  coreutils,
  gnugrep,
  which,
  gawk,
}:

let
  version = "3.0.0-1";
  model = "dcpj100";
in
{
  driver = pkgsi686Linux.stdenv.mkDerivation {
    pname = "${model}-lpr";
    inherit version;

    src = fetchurl {
      url = "https://download.brother.com/welcome/dlf100907/dcpj100lpr-${version}.i386.deb";
      hash = "sha256-kVvums/2/zBNiPCnLvkOs1v07TiNXdIpC9nUsWJlRnw=";
    };

    nativeBuildInputs = [
      dpkg
      makeWrapper
    ];
    buildInputs = [
      cups
      ghostscript
      a2ps
      gawk
    ];
    unpackPhase = "dpkg-deb -x $src $out";

    installPhase = ''
      substituteInPlace $out/opt/brother/Printers/${model}/lpd/filter${model} \
      --replace-fail /opt "$out/opt"

      patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $out/opt/brother/Printers/${model}/lpd/br${model}filter

      mkdir -p $out/lib/cups/filter/
      ln -s $out/opt/brother/Printers/${model}/lpd/filter${model} $out/lib/cups/filter/brother_lpdwrapper_${model}

      wrapProgram $out/opt/brother/Printers/${model}/lpd/filter${model} \
        --prefix PATH ":" ${
          lib.makeBinPath [
            gawk
            ghostscript
            a2ps
            file
            gnused
            gnugrep
            coreutils
            which
          ]
        }
    '';

    meta = {
      homepage = "http://www.brother.com/";
      description = "Brother ${model} printer driver";
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      license = lib.licenses.unfree;
      platforms = lib.platforms.linux;
      downloadPage = "https://support.brother.com/g/b/downloadlist.aspx?c=gb&lang=en&prod=${model}_eu&os=128";
    };
  };

  cupswrapper = stdenv.mkDerivation {
    pname = "${model}-cupswrapper";
    inherit version;

    src = fetchurl {
      url = "https://download.brother.com/welcome/dlf100909/dcpj100cupswrapper-${version}.i386.deb";
      hash = "sha256-XFBnyYDe3NyQgTNeHmzONCBNOkmgLeCw5cIl9q1y4JY=";
    };

    nativeBuildInputs = [
      dpkg
      makeWrapper
    ];
    buildInputs = [
      cups
      ghostscript
      a2ps
      gawk
    ];
    unpackPhase = "dpkg-deb -x $src $out";

    installPhase = ''
      for f in $out/opt/brother/Printers/${model}/cupswrapper/cupswrapper${model}; do
        wrapProgram $f --prefix PATH : ${
          lib.makeBinPath [
            coreutils
            ghostscript
            gnugrep
            gnused
          ]
        }
      done

      mkdir -p $out/share/cups/model
      ln -s $out/opt/brother/Printers/${model}/cupswrapper/brother_${model}_printer_en.ppd $out/share/cups/model/
    '';

    meta = {
      homepage = "http://www.brother.com/";
      description = "Brother ${model} printer CUPS wrapper driver";
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      license = lib.licenses.unfree;
      platforms = lib.platforms.linux;
      downloadPage = "https://support.brother.com/g/b/downloadlist.aspx?c=gb&lang=en&prod=${model}_eu&os=128";
    };
  };
}
