module Sub2 where

import Prelude

import Effect (Effect)
import Effect.Console (log)

-- import Data.Int
-- import Data.Maybe
import Effect.Ref (Ref, new, read, write)

import Control.Monad.Reader (ReaderT, ask, lift)
import Control.Monad.Reader.Trans as T

-- square :: Reader Int String
-- square = do
--   x <- ask
--   pure $ (toStringAs decimal x) <> "OKOK"

-- main :: Effect Unit
-- main = do
--   let x = 10
--   let y = runReader square x
--   log $ show y
--   pure unit

square :: ReaderT (Ref Int) Effect Unit
square = do
  ref <- ask
  lift $ do
    x <- read ref
    write (x*x) ref
    pure unit

newtype EX a = EX (ReaderT (Ref Int) Effect a)

square2 :: EX Unit
square2 = EX square2'

square2' :: ReaderT (Ref Int) Effect Unit
square2' = do
  ref <- ask
  lift $ do
    x <- read ref
    write (2*x*x) ref
    pure unit

main :: Effect Unit
main = do
  v <- new 10
  -- T.runReaderT square v
  let (EX calc) = square2
  T.runReaderT calc v
  y <- read v
  log $ show y