module Lib
    ( MyApp(..)
    , runApp
    ) where


import Yesod
import Data.Text qualified as T
import GHC.Generics ( Generic )
import Database.Persist.Sql (ConnectionPool, SqlBackend, runSqlPool)
import Control.Monad.Logger (runStderrLoggingT)
import MyAppEnv
import MyAppRepo

type JsonValue = Value

data MyApp
    = MyApp
    { pool :: ConnectionPool
    }

mkYesod "MyApp" [parseRoutes|
/      HomeR  GET
/users UsersR GET
|]

instance Yesod        MyApp
instance YesodPersist MyApp where
    type YesodPersistBackend MyApp = SqlBackend

    runDB action = do
        app <- getYesod
        runSqlPool action app.pool

data HomeResponse
    = HomeResponse
    { message :: T.Text
    , ok :: Bool
    } deriving (Generic, Show)

defaultHomeResponse :: HomeResponse
defaultHomeResponse = HomeResponse "" False

instance ToJSON HomeResponse

getHomeR :: Handler JsonValue
getHomeR = returnJson $ defaultHomeResponse { message = "hello" }

getUsersR :: Handler JsonValue
getUsersR = do
    users <- runDB getUsers
    returnJson $ map entityVal users


runApp :: Int -> MyAppEnv -> IO ()
runApp port env = do
    -- print env

    runStderrLoggingT $ withPool env $ \pool -> liftIO $ do
        warp port (MyApp pool)

