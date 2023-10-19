module Lib
    ( MyApp(..)
    , runApp
    ) where


import Yesod
import Data.Text qualified as T
import GHC.Generics ( Generic )
import MyAppEnv

type JsonValue = Value

data MyApp = MyApp

mkYesod "MyApp" [parseRoutes|
/ HomeR GET
|]

instance Yesod MyApp

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

runApp :: Int -> MyAppEnv -> IO ()
runApp port env = do
    print env
    warp port MyApp

