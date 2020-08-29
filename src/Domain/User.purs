module Domain.User
  ( UserType
  , User(..)
  ) where

import Prelude
import Simple.JSON (read, class ReadForeign, readImpl)
import Data.Int (decimal, toStringAs)
import Data.Maybe

type UserType =
  { id :: Maybe Int
  , firstName :: String
  , lastName :: String
  }

data User = User UserType

instance showUser :: Show User where
  show (User user) =
    "User { id:" <> (toStringAs decimal (fromMaybe 0 user.id)) 
    <> ", firstName: '" <> user.firstName <> "'"
    <> ", lastName: '" <> user.lastName <> "' }"

instance readUser :: ReadForeign User where
  readImpl text = do
    (user :: UserType) <- readImpl text
    pure $ User user

