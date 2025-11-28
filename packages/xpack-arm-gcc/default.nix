
{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation rec {
  pname = "xpack-arm-none-eabi-gcc";
  version = "14.2.1-1.1";

  src = fetchurl {
    url = "https://github.com/xpack-dev-tools/arm-none-eabi-gcc-xpack/releases/download/v${version}/xpack-arm-none-eabi-gcc-${version}-darwin-arm64.tar.gz";
    sha256 = "sha256-9S6jdgxTsl1yanNFvmCiEHNik9uF+S2qOdHSLTTiyZU=";
  };

  # 解凍後のディレクトリ名を自動検出させる！
  sourceRoot = "xpack-arm-none-eabi-gcc-${version}";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/lib
    mkdir -p $out/libexec
    mkdir -p $out/share
    mkdir -p $out/arm-none-eabi

    # バイナリとライブラリをコピー
    cp -r bin/* $out/bin/ || true
    cp -r lib/* $out/lib/ || true
    cp -r libexec/* $out/libexec/ || true
    cp -r share/* $out/share/ || true
    cp -r arm-none-eabi/* $out/arm-none-eabi/ || true
    # ドキュメント用のディレクトリを作成（衝突を避けるため専用の場所に）
    mkdir -p $out/share/doc/${pname}
    cp README*.md $out/share/doc/${pname}/ || true

    runHook postInstall
  '';

  meta = with lib; {
    description = "xPack GNU Arm Embedded GCC";
    homepage = "https://xpack.github.io/arm-none-eabi-gcc/";
    license = licenses.gpl3;
    platforms = [ "aarch64-darwin" ];
  };
}
