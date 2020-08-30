module Domain.User
  ( UnregisteredUserType
  , UserType
  , User(..)
  ) where

import Data.Maybe (Maybe)

type UnregisteredUserType =
  { firstName :: String
  , lastName :: String
  }

type UserType =
  { id :: Maybe Int
  , firstName :: String
  , lastName :: String
  }

data User = User UserType
