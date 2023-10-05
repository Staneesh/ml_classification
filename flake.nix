{
    description = "Machine Learning in Finance II Project on Classification";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    };
    outputs = { self, nixpkgs }:
    let 
        system = "x86_64-linux"; 
        pkgs = (import nixpkgs) { inherit system; };
    in
    {
        devShells.${system}.default = pkgs.mkShell {
            buildInputs = with pkgs; [
                pkgs.quarto
                pkgs.poetry
            ];
            shellHook = ''
                ${pkgs.poetry}/bin/poetry env use 3.11
            '';
        };

        packages.${system}.main = pkgs.stdenv.mkDerivation rec{
            name = "main";
            src = ./.;
            nativeBuildInputs = with pkgs; [ 
                pkgs.quarto
                pkgs.poetry
            ];
            shellHook = ''
                ${pkgs.poetry}/bin/poetry env use 3.11
            '';
            buildPhase = ''
                ${pkgs.poetry}/bin/poetry install
            '';
            installPhase = ''
                ${pkgs.quarto}/bin/quarto render"
            '';
        };
    };
}

