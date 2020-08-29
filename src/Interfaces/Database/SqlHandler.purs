module Interfaces.Database.SqlHandler
  (
    class SqlHandler
  , query
  , execute
  , SqlHandlerType
  , mkSqlHandler
  ) where

import Type.Proxy (Proxy)
import Effect.Aff (Aff)
import Control.Monad.Reader.Trans (ReaderT, runReaderT)

type SqlHandlerType result = {
  query :: forall params. String -> Record params -> Aff (Array result)
, execute :: forall params. String -> Record params ->Aff (Proxy result)
}

mkSqlHandler :: forall ds result. (SqlHandler ds result) => ds -> SqlHandlerType result
mkSqlHandler ds = {
  query: \queryString params -> runReaderT (query queryString params) ds 
, execute: \queryString params -> runReaderT (execute queryString params) ds
}

class SqlHandler ds result where
  query :: forall params. String -> Record params -> (ReaderT ds Aff) (Array result)
  execute :: forall params. String -> Record params -> (ReaderT ds Aff) (Proxy result)