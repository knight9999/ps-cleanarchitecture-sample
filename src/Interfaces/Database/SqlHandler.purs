module Interfaces.Database.SqlHandler
  (
    class SqlHandler
  , query
  ) where

import Effect (Effect)
import Effect.Aff (Aff)

class SqlHandler ds result where
  query :: forall params. String -> Record params -> ds -> Aff (Array result)
