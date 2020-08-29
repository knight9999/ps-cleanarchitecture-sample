module Interfaces.Database.SqlHandler
  (
    class SqlHandler
  , query
  , execute
  ) where

import Prelude
import Type.Proxy

import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Aff.Class (class MonadAff)

import Control.Monad
import Control.Monad.Reader.Trans

-- class (Monad repr) <= SqlHandler repr result where
--   query :: forall params. String -> Record params -> repr (Array result)


class SqlHandler ds result where
  query :: forall params. String -> Record params -> (ReaderT ds Aff) (Array result)
  execute :: forall params. String -> Record params -> (ReaderT ds Aff) (Proxy result)