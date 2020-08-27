module Interfaces.Database.SqlHandler
  (
    class SqlHandler
  , query
  ) where

import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Aff.Class (class MonadAff)

class (MonadAff m) <= SqlHandler ds m result where
  query :: forall params. String -> Record params -> ds -> m (Array result)
