module MyAppEnv
  ( MyAppEnv(..)
  , readMyAppEnv
  ) where

import Data.Text.Lazy qualified as T
import Configuration.Dotenv (loadFile, defaultConfig)
import System.Environment.Blank (getEnv)

type EnvText = Maybe T.Text

data MyAppEnv
  = MyAppEnv
  { dbUser :: T.Text
  , dbPassword :: T.Text
  , dbName :: T.Text
  } deriving (Show)

readMyAppEnv :: IO (Maybe MyAppEnv)
readMyAppEnv = do
  loadFile defaultConfig
  mkMyAppEnv
    <$> getEnvText "PG_USER"
    <*> getEnvText "PG_PASSWORD"
    <*> getEnvText "DB_NAME"

getEnvText :: String -> IO EnvText
getEnvText key = do
  value <- getEnv key
  return $ T.pack <$> value

mkMyAppEnv :: EnvText -> EnvText -> EnvText -> Maybe MyAppEnv
mkMyAppEnv user password dbName =
  MyAppEnv
    <$> user
    <*> password
    <*> dbName