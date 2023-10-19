{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE DataKinds #-}


module MyAppRepo (getUsers, withPool) where

import Data.Pool (Pool)
import Database.Persist
import Database.Persist.Postgresql
import Database.Persist.TH
import Control.Monad.Trans.Reader (ReaderT)
import Control.Monad.Logger (MonadLoggerIO)
import Yesod
import GHC.Generics ( Generic )


import Data.Text qualified as T
import Data.Text.Encoding qualified as T (encodeUtf8)
import Text.Shakespeare.Text (st)
import MyAppEnv

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
User sql=users
  name T.Text
  deriving Show Generic
|]

instance ToJSON User


getUsers :: MonadIO m => ReaderT SqlBackend m [Entity User]
getUsers = do
  users <- selectList [] []
  return users

withPool  ::  (MonadLoggerIO m, MonadUnliftIO m)
          =>  MyAppEnv
          ->  (Pool SqlBackend -> m a)
          ->  m a
withPool env = withPostgresqlPool cs 10
  where
    cs = toConnectionString env

-- cs = "host=localhost port=5432 user=test dbname=test password=test"

toConnectionString :: MyAppEnv -> ConnectionString
toConnectionString env = T.encodeUtf8 [st|
  host=localhost
  port=5432
  user=#{env.dbUser}
  password=#{env.dbPassword}
  dbname=#{env.dbName}
|]


