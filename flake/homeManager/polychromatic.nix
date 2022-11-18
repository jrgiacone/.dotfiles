{ lib
, fetchFromGitHub
, bash
, glib
, qt5
, gdk-pixbuf
, gettext
, imagemagick
, ninja
, meson
, sassc
, libxcb
, python3Packages
, gobject-introspection
, libappindicator-gtk3
, qtsvg
, gtk3
, wrapGAppsHook
}:

python3Packages.buildPythonApplication rec {
  name = "polychromatic";
  version = "0.7.3";
  format = "other";

  src = fetchFromGitHub {
    owner = "polychromatic";
    repo = "polychromatic";
    rev = "v${version}";
    sha256 = "sha256-H++kQ3Fxw56avEsSE1ctu5p0s50s0eQ+jL5zXS3AA94=";
  };

  postPatch = ''
    patchShebangs scripts
    substituteInPlace scripts/build-styles.sh \
      --replace '$(which sassc 2>/dev/null)' '${sassc}/bin/sassc' \
      --replace '$(which sass 2>/dev/null)' '${sassc}/bin/sass'
    substituteInPlace pylib/common.py \
      --replace "/usr/share/polychromatic" "$out/share/polychromatic"
  '';

  preConfigure = ''
    scripts/build-styles.sh
  '';

  nativeBuildInputs = with python3Packages; [
    gettext
    gobject-introspection
    meson
    ninja
    sassc
    wrapGAppsHook
    qt5.wrapQtAppsHook
    qtsvg
  ];

  propagatedBuildInputs = with python3Packages; [
    colorama
    colour
    gtk3
    openrazer
    pygobject3
    pyqt5
    pyqtwebengine
    requests
    setproctitle
  ];

  dontWrapGapps = true;
  dontWrapQtApps = false;

  makeWrapperArgs = [
    "\${gappsWrapperArgs[@]}"
  ];

  meta = with lib; {
    homepage = "https://polychromatic.app/";
    description = "Graphical front-end and tray applet for configuring Razer peripherals on GNU/Linux.";
    longDescription = ''
      Polychromatic is a frontend for OpenRazer that enables Razer devices
      to control lighting effects and more on GNU/Linux.
    '';
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ evanjs ];
  };
}
