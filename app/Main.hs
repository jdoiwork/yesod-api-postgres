module Main (main) where

import Lib
import MyAppEnv

main :: IO ()
main = do
  myAppEnv <- readMyAppEnv
  case myAppEnv of
    Just env -> runApp 3000 env
    Nothing -> putStrLn "Invalid .env file."
