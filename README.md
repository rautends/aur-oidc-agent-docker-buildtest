File             | Description                                                                                      | 
---------------- | ------------------------------------------------------------------------------------------------ | 
./00clean.sh     | Script to clean up any previous build artifacts.                                                 | 
./build.sh       | Script to build the OIDC agent package using the PKGBUILD and cmd startpoint for the Dockerfile. | 
./Dockerfile     | Dockerfile to set up the environment for building and testing the OIDC agent package.            | 
./docker-run.sh  | Script to run the Docker container for building and testing the package.                         | 
./install-zst.sh | Script to install the built package from the compressed .zst file.                               | 
./PKGBUILD       | The PKGBUILD file that defines how the OIDC agent package is built.                              | 
