{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  texliveInfraOnly,

  # build-system
  setuptools,

  # dependencies
  addict,
  appdirs,
  colour,
  diskcache,
  ipython,
  isosurfaces,
  manimpango,
  mapbox-earcut,
  moderngl,
  moderngl-window,
  numpy,
  pillow,
  pydub,
  pygments,
  pyopengl,
  rich,
  scipy,
  screeninfo,
  skia-pathops,
  svgelements,
  sympy,
  tqdm,
  typing-extensions,
  validators,

  # tests
  ffmpeg,
  pytest-cov-stub,
  pytest-xdist,
  pytestCheckHook,
  versionCheckHook,
}:


let
  # This is a list of all LaTeX packages used by manimgl according to manimlib/tex_templates.yml
  manim-tex = texliveInfraOnly.withPackages (
    ps: with ps; [
      babel
      inputenc
      fontenc
      amsmath
      amssymb
      dsfont
      setspace
      tipa
      relsize
      textcomp
      mathrsfs
      calligra
      wasysym
      ragged2e
      physics
      xcolor
      microtype
      pifont
      mathastext
      txfonts
      txgreeks
      fontspec
      xeCJK
      aurical
      baskervald
      comfortaa
      droidsans
      droidserif
      frcursive
      electrum
      epigrafica
      fourier
      gnu_freesans
      gnu_freeserif
      helvetica
      pxfonts
      eulergreek
      symbol
      lmodern
      antpolt
      uop
      udidot
      neohellenic
      fau
      fjd
      fsk
      ftp
      fwb
    ]
  );
in
buildPythonPackage rec {
  pyname = "manimgl";
  pyproject = true;
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "3b1b";
    repo = "manim";
    tag = "v${version}";
    hash = "sha256-0gsy3mglwwdarf3r0s8qqcdmxmm20av6ryz6n1wh01gp0psxzr44";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    addict
    appdirs
    colour
    diskcache
    ipython
    isosurfaces
    manimpango
    mapbox-earcut
    moderngl
    moderngl-window
    numpy
    pillow
    pydub
    pygments
    pyopengl
    rich
    scipy
    screeninfo
    skia-pathops
    svgelements
    sympy
    tqdm
    typing-extensions
    validators
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      ffmpeg
      manim-tex
    ])
  ];

  nativeCheckInputs = [
    ffmpeg
    manim-tex
    pytest-cov-stub
    pytest-xdist
    pytestCheckHook
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];

  pythonImportsCheck = [ "manimlib" ];

  meta = {
    description = "Animation engine for explanatory math videos";
    longDescription = ''
      Manim is an engine for precise programmatic animations, designed for creating
      explanatory math videos, as seen in the videos of 3Blue1Brown on Youtube.
      This is the original version that is maintained by Grant Sanderson which is
      based on OpenGL.
    '';
    changelog = "https://3b1b.github.io/manim/development/changelog.html";
    homepage = "https://github.com/3b1b/manim";
    license = lib.licenses.mit;
    maintainers = [];
  };
}
