{-# LANGUAGE PatternSynonyms #-}
{-# LANGUAGE TemplateHaskell #-}

module Program where

import Raylib.Core
import Raylib.Core.Camera (updateCamera)
import Raylib.Core.Models
import Raylib.Core.Text
import Raylib.Types
import Raylib.Util (drawing, mode3D, raylibApplication)
import Raylib.Util.Colors
import Control.Monad (when, unless)

startup :: IO Camera3D
startup = do
  initWindowUnmanaged 1000 600 "raylib web demo"
  setTargetFPS 60

  return $ Camera3D (Vector3 3 2 3) (Vector3 0 0 0) (Vector3 0 1 0) 70 CameraPerspective

mainLoop :: Camera3D -> IO Camera3D
mainLoop camera =
  drawing
    ( do
        hidden <- isCursorHidden
        camera' <- if hidden then updateCamera camera CameraModeFirstPerson else return camera
        if hidden
          then do
            esc <- isKeyPressed KeyEscape
            when esc (showCursor >> enableCursor)
          else do
            pressed <- isMouseButtonPressed MouseButtonLeft
            when pressed (hideCursor >> disableCursor)

        clearBackground white

        mode3D
          camera
          ( do
              drawGrid 20 2.0
              drawCube (Vector3 0 1.5 0) 2 3 4 orange
              drawSphere (Vector3 (-5) 1 0) 1 red
          )

        drawFPS 10 20
        unless hidden (drawText "Click anywhere on-screen to play!" 10 40 20 black)

        return camera'
    )

shouldClose :: Camera3D -> IO Bool
shouldClose _ = windowShouldClose

teardown :: Camera3D -> IO ()
teardown _ = closeWindow Nothing

raylibApplication 'startup 'mainLoop 'shouldClose 'teardown
