module Infrastructure.SqlHandler
  ( DataStoreType
  , DataStore(..)
  -- , SqlHandlerImpl(..)
  ) where

import Prelude
import Data.Either (Either(..))

import Effect.Aff (Aff, launchAff)
import Simple.JSON (read, class ReadForeign)
import SQLite3 (DBConnection, closeDB, newDB, queryDB, queryObjectDB) as SQ3 
import Interfaces.Database.SqlHandler as IDS
import Control.Monad.Reader.Trans

type DataStoreType =
  {
    conn :: SQ3.DBConnection
  }

newtype DataStore = DataStore DataStoreType

-- type SqlHandlerImplType = ReaderT DataStore Aff
-- newtype SqlHandlerImpl results = SqlHandlerImpl (ReaderT DataStore Aff results)

-- derive newtype instance functorSqlHandlerImpl :: Functor SqlHandlerImpl
-- derive newtype instance applySqlHandlerImpl :: Apply SqlHandlerImpl
-- derive newtype instance applicativeSqlHandlerImpl :: Applicative SqlHandlerImpl
-- derive newtype instance bindSqlHandlerImpl :: Bind SqlHandlerImpl
-- derive newtype instance monadSqlHandlerImpl :: Monad SqlHandlerImpl

instance sqlHandlerImpl :: 
  ( ReadForeign result
  ) => IDS.SqlHandler DataStore result
  where
    query queryString params = (query_ queryString params)

query_ :: forall params result. (ReadForeign result) => 
            String -> Record params ->
            (ReaderT DataStore Aff (Array result))
query_ queryString params = do
  (DataStore ds) <- ask
  lift do
    results <- read <$> SQ3.queryObjectDB ds.conn queryString params
    case results of
      Right (results :: Array result) ->
        pure results
      Left e ->
        pure []