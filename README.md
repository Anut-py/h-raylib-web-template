# h-raylib-web-template

Based on https://github.com/Anut-py/ghc-web-test

## Prerequisites

To run this project you will need to have installed Nix, Cabal, Emscripten, and NodeJS

**IMPORTANT: This does not work with recent emscripten versions, it does work with emscripten 3.1.45**

## Running the code

### Compile the Haskell code

Run the following command (you will need to do this in WSL if you're on Windows):

```sh
nix shell https://gitlab.haskell.org/ghc/ghc-wasm-meta/-/archive/master/ghc-wasm-meta-master.tar.gz --extra-experimental-features nix-command --extra-experimental-features flakes
```

This will enter a nix flake with the GHC to WASM compiler available. Now run
the `build_haskell.sh` file in this flake. This will compile the Haskell code
with all the necessary configurations.

You can then run `exit` to terminate the Nix flake.

### Compile the raylib code

Run the `build_raylib.sh` file (you will need to use Git Bash if you're on
Windows). This will compile the raylib C code to WebAssembly.

### Start the frontend server

Run the following commands in this directory:

```sh
npm install
npm run serve
```

This will start up a server and open a window to localhost:8080.

If you want to make changes to the TS code, you can edit it and the server will automatically refresh. To make changes to the Haskell code, run the `build_haskell.sh` script after you edit the code.
