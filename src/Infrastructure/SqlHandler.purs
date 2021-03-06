module Infrastructure.SqlHandler
  ( DataStoreType
  , DataStore(..)
  , module IDS
  ) where

import Prelude (bind, pure, (<$>))
import Data.Either (Either(..))
import Type.Proxy (Proxy(..))
import Effect.Aff (Aff)
import Simple.JSON (read, class ReadForeign)
import SQLite3 (DBConnection, queryObjectDB) as SQ3

import Interfaces.Database.SqlHandler (class SqlHandler, SqlHandlerType, execute, mkSqlHandler, query) as IDS
import Control.Monad.Reader.Trans (ReaderT, ask, lift)

type DataStoreType =
  {
    conn :: SQ3.DBConnection
  }

newtype DataStore = DataStore DataStoreType

instance sqlHandlerImpl :: 
  ( ReadForeign result
  ) => IDS.SqlHandler DataStore result
  where
    query queryString params = (query_ queryString params)
    execute executeString params = (execute_ executeString params)

query_ :: forall params result. (ReadForeign result) => 
            String -> Record params ->
            (ReaderT DataStore Aff (Array result))
query_ queryString params = do
  (DataStore ds) <- ask
  lift do
    results <- read <$> SQ3.queryObjectDB ds.conn queryString params
    case results of
      Right (results' :: Array result) ->
        pure results'
      Left e ->
        pure []

execute_ :: forall params result. 
            String -> Record params ->
            (ReaderT DataStore Aff (Proxy result))
execute_ queryString params = do
  (DataStore ds) <- ask
  lift do
    _ <- SQ3.queryObjectDB ds.conn queryString params
    pure Proxy