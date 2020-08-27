module Infrastructure.SqlHandler
  where

import Prelude
import Data.Either (Either(..))

import Effect.Aff (launchAff)
import Simple.JSON (read, class ReadForeign)
import SQLite3 (DBConnection, closeDB, newDB, queryDB, queryObjectDB) as SQ3 
import Interfaces.Database.SqlHandler as IDS

type DataStoreType =
  {
    conn :: SQ3.DBConnection
  }

newtype DataStore = DataStore DataStoreType

instance sqlHandlerImpl :: 
  ( ReadForeign result
  ) => IDS.SqlHandler DataStore result
  where
    query queryString params (DataStore ds) = do
      results <- read <$> SQ3.queryObjectDB ds.conn queryString params
      case results of
        Right (results :: Array result) ->
          pure results
        Left e ->
          pure []

