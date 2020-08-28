module Sub where

import Prelude

import Effect (Effect)
import Effect.Console (log, error)

import Data.Maybe

import Effect.Ref (Ref(..), modify) as Ref
import Control.Monad.Reader.Trans as T
import Data.Array

-- Class Definition
class Monad repr <= DataStoreSym repr where
  create :: String -> String -> repr Unit
  read   :: String           -> repr (Maybe String)


-- -- Store Ref
-- type RefDS = T.ReaderT (Ref.Ref (Array {key :: String, value :: String})) Effect
-- newtype RefDSwrap a = RefDSwrap (RefDS a)
-- -- derive newtype instance monadAskRefDSwrap :: MonadAsk (Ref.Ref (Array {key :: String, value :: String})) RefDSwrap

-- instance dataStoreSYMRef :: DataStoreSym RefDSwrap where
--   create k v = do
--     ref <- T.ask
--     T.lift $ Ref.modify (\list -> ({key: k, value: v}:list)) ref
--   read   k   = do
--     ref <- T.ask
--     T.lift $ find <$> read ref

-- (RefDSwrap ref) <- ask
-- この取得方法だと、refは、Refになってしまう

-- ref <- ask
-- この取得方法だと、t2 Effectになっている？


-- refは、次のようになっている必要がある。
-- ReaderT                  
--   (Ref                   
--      (Array              
--         { key :: String  
--         , value :: String
--         }                
--      )                   
--   )                      
--   Effect    


-- Store Mock
instance dataStoreSYMEffect :: DataStoreSym Effect where
  create k v = log $ "Create: " <> k <> ", " <> v
  read   k   = Nothing <$ (log $ "Read: " <> k)

main :: Effect Unit
main = do
  create "KEY" "VALUE"
  _ <- read "KEY2"
  pure unit