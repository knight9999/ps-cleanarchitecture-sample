module Interfaces.Database.SqlHandler
  (
    class SqlHandler
  , query
  ) where

import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Aff.Class (class MonadAff)

import Control.Monad

-- class SqlHandler ds m result where
--   query :: forall params. String -> Record params -> ds -> m (Array result)

class (Monad repr) <= SqlHandler repr result where
  query :: forall params. String -> Record params -> repr (Array result)

-- repr means ReaderT ds (m (Array result))
