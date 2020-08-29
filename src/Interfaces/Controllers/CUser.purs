module Interfaces.Controllers.CUser
  ( CUser(..)
  ) where

import Prelude
import Simple.JSON (class ReadForeign, readImpl, class WriteForeign, writeImpl)
import Data.Int (decimal, toStringAs)
import Data.Maybe (Maybe, fromMaybe)

import Domain.User

newtype CUser = CUser User

instance readCUser :: ReadForeign CUser where
  readImpl text = do
    (user :: UserType) <- readImpl text
    pure $ CUser (User user)

instance writeCUser :: WriteForeign CUser where
  writeImpl (CUser (User user)) = writeImpl user


instance showCUser :: Show CUser where
  show (CUser (User user)) =
    "User { id:" <> (toStringAs decimal (fromMaybe 0 user.id)) 
    <> ", firstName: '" <> user.firstName <> "'"
    <> ", lastName: '" <> user.lastName <> "' }"