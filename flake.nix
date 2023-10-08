{
  	description = "Containterized Python Application";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/release-23.05";

	};
	
  	outputs = { self, nixpkgs }:
	let
		system = "x86_64-linux";
		pkgs = import nixpkgs { inherit system; };
		project_tag = "ml_classification";
		requirements = pkgs.writeTextDir "/usr/src/${project_tag}/requirements.txt" ''
			pandas
			numpy
			scikit-learn
			matplotlib
			scipy
			dowhy
			seaborn
			tqdm
			statsmodels
		'';
		setup = pkgs.writeTextDir "/usr/src/${project_tag}/setup.sh" ''
			#!/bin/sh

			apt-get update && apt-get install -y python3.8 python3-pip python3.8-venv vim

			python3.8 -m venv env && . env/bin/activate

			pip install -r requirements.txt

			mkdir output

			pip freeze > output/requirements.txt
		'';
	in
	{
		devShells.${system}.default = pkgs.mkShell {
			buildInputs = with pkgs; [ ];
		};

		packages.${system}.default = pkgs.dockerTools.buildImage {
      			name = "${project_tag}";
			tag = "latest";

			fromImage = pkgs.dockerTools.pullImage {
				imageName = "nvidia/cuda";
				imageDigest = "sha256:cd59e2522b130d72772cc7db4d63f3eedbc981138f825694655bb66e4c7dd2e3";
				sha256 = "sha256-UtwAbxScNzGZ37ymvH5Jk7ltW6uVX0C2ltUQFsFdPXg=";
				os = "linux";
				arch = "x86_64";
			}; 

			created = "now";

			copyToRoot = pkgs.buildEnv {
				name = "image-root";
				paths = [ 
#					pkgs.coreutils 
#					pkgs.util-linux 
#					pkgs.python38 
#					pkgs.python38Packages.pip 
#					pkgs.python38Packages.numpy 
#					pkgs.python38Packages.pandas 
					requirements 
					setup
					pkgs.dockerTools.binSh
				];
#				pathsToLink = [ "/bin" "/usr" ];
			};			

			config = {
				WorkingDir = "/usr/src/${project_tag}";
				Env = [
					"TZ=Europe/Warsaw"
					"DEBIAN_FRONTEND=noninteractive"
				];
				Cmd = [
					"/bin/sh"
				];
				Volumes = {
					"output" = {};
				};
			};
	    	};
	};
}
