module Domain.User
  ( UserType
  , User(..)
  ) where

import Data.Maybe (Maybe)

type UserType =
  { id :: Maybe Int
  , firstName :: String
  , lastName :: String
  }

data User = User UserType
