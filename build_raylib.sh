EMCC=emcc
EMAR=emar

set -e
echo "Checking if raylib is built..."
if [ ! -f "h-raylib/raylib/src/libraylib.so" ]; then
# if [ ! -f "h-raylib/raylib/src/libraylib.a" ]; then
  echo "raylib archive does not exist"
  echo $'Building raylib...\n'

  cd h-raylib/raylib/src

  # $EMCC -c rcore.c -pthread -Os -Wall -DPLATFORM_WEB -DGRAPHICS_API_OPENGL_ES2
  # $EMCC -c rshapes.c -pthread -Os -Wall -DPLATFORM_WEB -DGRAPHICS_API_OPENGL_ES2
  # $EMCC -c rtextures.c -pthread -Os -Wall -DPLATFORM_WEB -DGRAPHICS_API_OPENGL_ES2
  # $EMCC -c rtext.c -pthread -Os -Wall -DPLATFORM_WEB -DGRAPHICS_API_OPENGL_ES2
  # $EMCC -c rmodels.c -pthread -Os -Wall -DPLATFORM_WEB -DGRAPHICS_API_OPENGL_ES2
  # $EMCC -c raudio.c -pthread -Os -Wall -DPLATFORM_WEB
  
  $EMCC -c rcore.c -pthread -Os -Wall -DPLATFORM_WEB -DGRAPHICS_API_OPENGL_ES2 -fPIC -DBUILD_LIBTYPE_SHARED $OPTIONS
  $EMCC -c rshapes.c -pthread -Os -Wall -DPLATFORM_WEB -DGRAPHICS_API_OPENGL_ES2 -fPIC -DBUILD_LIBTYPE_SHARED $OPTIONS
  $EMCC -c rtextures.c -pthread -Os -Wall -DPLATFORM_WEB -DGRAPHICS_API_OPENGL_ES2 -fPIC -DBUILD_LIBTYPE_SHARED $OPTIONS
  $EMCC -c rtext.c -pthread -Os -Wall -DPLATFORM_WEB -DGRAPHICS_API_OPENGL_ES2 -fPIC -DBUILD_LIBTYPE_SHARED $OPTIONS
  $EMCC -c rmodels.c -pthread -Os -Wall -DPLATFORM_WEB -DGRAPHICS_API_OPENGL_ES2 -fPIC -DBUILD_LIBTYPE_SHARED $OPTIONS
  $EMCC -c raudio.c -pthread -Os -Wall -DPLATFORM_WEB -fPIC -DBUILD_LIBTYPE_SHARED $OPTIONS

  # $EMAR rcs libraylib.a rcore.o rshapes.o rtextures.o rtext.o rmodels.o raudio.o
  $EMCC -shared -o libraylib.so rcore.o rshapes.o rtextures.o rtext.o rmodels.o raudio.o

  cd ../../..

  echo $'\nraylib archive built successfully, continuing\n'
else
  echo $'raylib archive already exists, continuing\n'
fi

echo $'Compiling bindings...'

# $EMCC h-raylib/lib/*.c h-raylib/raylib/src/libraylib.a \
$EMCC h-raylib/lib/*.c h-raylib/raylib/src/libraylib.so \
  -Ih-raylib/raylib/src \
  -Ih-raylib/raygui/src \
  -Ih-raylib/raygui/styles/advance \
  -Ih-raylib/raygui/styles/amber \
  -Ih-raylib/raygui/styles/ashes \
  -Ih-raylib/raygui/styles/bluish \
  -Ih-raylib/raygui/styles/brick \
  -Ih-raylib/raygui/styles/candy \
  -Ih-raylib/raygui/styles/cherry \
  -Ih-raylib/raygui/styles/cyber \
  -Ih-raylib/raygui/styles/dark \
  -Ih-raylib/raygui/styles/enefete \
  -Ih-raylib/raygui/styles/genesis \
  -Ih-raylib/raygui/styles/jungle \
  -Ih-raylib/raygui/styles/lavanda \
  -Ih-raylib/raygui/styles/pocket \
  -Ih-raylib/raygui/styles/rltech \
  -Ih-raylib/raygui/styles/sunny \
  -Ih-raylib/raygui/styles/terminal \
  -Ih-raylib/raygui/styles/turbo \
  -Ih-raylib/raygui/styles/wisteria \
  -DPLATFORM_WEB \
  -DGRAPHICS_API_OPENGL_ES2 \
  \
  -sUSE_GLFW=3 \
  -sIMPORTED_MEMORY \
  -sSHARED_MEMORY \
  -sUSE_PTHREADS \
  -sALLOW_MEMORY_GROWTH \
  -sASYNCIFY \
  -sSTACK_SIZE=5MB \
  \
  -sMODULARIZE \
  -sEXPORT_NAME=Raylib \
  -sEXPORTED_RUNTIME_METHODS=ccall,cwrap,setMainLoop,wasmExports \
  \
  -Wno-pthreads-mem-growth \
  \
  -o raylib.js

echo $'Bindings compiled successfully!\n'

echo "Moving output files..."

rm -f ./public/raylib.wasm
mv raylib.wasm ./public

rm -f ./src/raylib.js
mv raylib.js ./src

rm -f raylib.worker.js

echo "Output files moved successfully!"
