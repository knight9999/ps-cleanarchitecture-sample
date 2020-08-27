module Domain.User
  ( UserType
  , User(..)
  ) where

type UserType =
  { id :: Int
  , firstName :: String
  , lastName :: String
  }

data User = User UserType

-- instance showUser :: Show User where
--   show (User user) =
--     "User { id:" <> (toStringAs decimal user.id) 
--     <> ", firstName: '" <> escape user.firstName <> "'"
--     <> ", lastName: '" <> escape user.lastName <> "' }"

-- instance readUser :: ReadForeign User where
--   readImpl text = do
--     (user :: UserType) <- readImpl text
--     pure $ User user

