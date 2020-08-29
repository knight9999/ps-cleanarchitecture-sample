module Domain.User
  ( UserType
  , User(..)
  ) where

import Prelude (class Show, bind, pure, ($), (<>))
import Simple.JSON (class ReadForeign, readImpl, class WriteForeign, writeImpl)
import Data.Int (decimal, toStringAs)
import Data.Maybe (Maybe, fromMaybe)

type UserType =
  { id :: Maybe Int
  , firstName :: String
  , lastName :: String
  }

data User = User UserType

-- instance showUser :: Show User where
--   show (User user) =
--     "User { id:" <> (toStringAs decimal (fromMaybe 0 user.id)) 
--     <> ", firstName: '" <> user.firstName <> "'"
--     <> ", lastName: '" <> user.lastName <> "' }"
