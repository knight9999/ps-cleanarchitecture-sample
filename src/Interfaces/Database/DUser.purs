module Interfaces.Database.DUser
  ( DUser(..)
  ) where

import Prelude (bind, pure, ($))
import Simple.JSON (class ReadForeign, readImpl, class WriteForeign, writeImpl)

import Domain.User (User(..), UserType)

newtype DUser = DUser User

instance readDUser :: ReadForeign DUser where
  readImpl text = do
    (user :: UserType) <- readImpl text
    pure $ DUser (User user)

instance writeDUser :: WriteForeign DUser where
  writeImpl (DUser (User user)) = writeImpl user
