module Lib
    ( MyApp(..)
    , runApp
    ) where


import           Yesod
import Data.Text qualified as T
import GHC.Generics

type JsonValue = Value

data MyApp = MyApp

mkYesod "MyApp" [parseRoutes|
/ HomeR GET
|]

instance Yesod MyApp

data HomeResponse
    = HomeResponse
    { message :: T.Text
    } deriving (Generic, Show)

instance ToJSON HomeResponse

getHomeR :: Handler JsonValue
getHomeR = returnJson $ HomeResponse "hello"

runApp :: Int -> IO ()
runApp port = warp port MyApp

