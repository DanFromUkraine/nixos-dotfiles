{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
}:

buildGoModule rec {
  pname = "hide-me";
  version = "0.9.12";

  src = fetchFromGitHub {
    owner = "eventure";
    repo = "hide.client.linux";
    rev = "f84de45183966c2205e669a488a49b5d3d843091";
    hash = "sha256-I4rqJsWw39y4D9yCHr/d3EISTB/7b0MomuaaYhd3GUk=";
  };
  vendorHash = "sha256-GDpGJFSvoPWkrgjNuMCoHNzTbiZTZUBtnIssduvRI+s=";
  ldflags = [
    "-s"
    "-w"
  ];
  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    install -Dm644 CA.pem $out/share/hide.me/CA.pem
    mv $out/bin/hide.client.linux $out/bin/hide-me
  '';

  postPatch = ''
    substituteInPlace rest/client.go \
      --replace-fail \
        '[]tls.CurveID{ tls.X25519MLKEM768 },' \
        '[]tls.CurveID{ tls.X25519MLKEM768, tls.X25519 },'
  '';

  postFixup = ''
    wrapProgram $out/bin/hide-me --add-flags "--ca $out/share/hide.me/CA.pem"
  '';

  meta = with lib; {
    description = "Hide.me CLI VPN client for Linux";
    homepage = "https://github.com/eventure/hide.client.linux";
    license = licenses.gpl2Only;
    mainProgram = "hide.me";
    platforms = platforms.linux;
  };
}
