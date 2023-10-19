module Lib
    ( HelloWorld(..)
    , runApp
    ) where


import           Yesod
import Data.Text qualified as T
import GHC.Generics

data HelloWorld = HelloWorld

mkYesod "HelloWorld" [parseRoutes|
/ HomeR GET
|]

instance Yesod HelloWorld

data HomeResponse
    = HomeResponse
    { message :: T.Text
    } deriving (Generic, Show)


instance ToJSON HomeResponse

getHomeR :: Handler Value
getHomeR = returnJson $ HomeResponse "hello"

runApp :: Int -> IO ()
runApp port = warp port HelloWorld

