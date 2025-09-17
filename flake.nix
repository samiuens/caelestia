{
  description = "Caelestia QML Plugin - Desktop shell for Caelestia dots";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    caelestia-cli = {
      url = "github:caelestia-dots/cli";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.caelestia-shell.follows = "";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      quickshell,
      caelestia-cli,
      ...
    }:
    let
      forAllSystems =
        fn: nixpkgs.lib.genAttrs nixpkgs.lib.platforms.linux (system: fn nixpkgs.legacyPackages.${system});
    in
    {
      formatter = forAllSystems (pkgs: pkgs.alejandra);

      packages = forAllSystems (pkgs: rec {
        qml-plugin = pkgs.stdenv.mkDerivation {
          name = "caelestia-qml-plugin";
          src = ./.;

          nativeBuildInputs = with pkgs; [
            cmake
            ninja
            pkg-config
          ];

          buildInputs = with pkgs; [
            qt6.qtmultimedia
            aubio
          ];

          dontWrapQtApps = true;

          cmakeFlags = [
            "-DCMAKE_BUILD_TYPE=RelWithDebInfo"
            "-DENABLE_MODULES=plugin"
            "-DINSTALL_QMLDIR=${placeholder "out"}/lib/qt6/qml"
            "-DVERSION=1.0.0"
            "-DGIT_REVISION=local"
          ];

          meta = {
            description = "Caelestia QML Plugin";
            homepage = "https://github.com/samiuens/caelestia";
            license = pkgs.lib.licenses.gpl3Only;
          };
        };

        shell = pkgs.callPackage ./nix {
          rev = self.rev or self.dirtyRev;
          stdenv = pkgs.clangStdenv;
          quickshell = quickshell.packages.${pkgs.system}.default.override {
            withX11 = false;
            withI3 = false;
          };
          app2unit = pkgs.callPackage ./nix/app2unit.nix { inherit pkgs; };
          caelestia-cli = caelestia-cli.packages.${pkgs.system}.default;
        };

        # Varianten
        # with-cli = caelestia-shell.override { withCli = true; };
        # debug = caelestia-shell.override { debug = true; };

        default = qml-plugin;
      });

      # Development Shell
      devShells = forAllSystems (pkgs: {
        default =
          let
            shell = self.packages.${pkgs.system}.caelestia-shell;
          in
          pkgs.mkShell.override { stdenv = shell.stdenv; } {
            inputsFrom = [
              shell
              shell.plugin
              shell.extras
            ];
            packages = with pkgs; [
              material-symbols
              rubik
              nerd-fonts.caskaydia-cove
            ];
            CAELESTIA_XKB_RULES_PATH = "${pkgs.xkeyboard-config}/share/xkeyboard-config-2/rules/base.lst";
          };
      });
    };
}
