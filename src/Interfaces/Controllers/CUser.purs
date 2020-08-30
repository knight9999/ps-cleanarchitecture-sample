module Interfaces.Controllers.CUser
  ( CUser(..)
  , fromInputRecord
  ) where

import Prelude (class Show, bind, pure, ($), (<>))
import Simple.JSON (class ReadForeign, readImpl, class WriteForeign, writeImpl)
import Data.Int (decimal, toStringAs)
import Data.Maybe (Maybe(..), fromMaybe)
import Record.Builder (build, merge)

import Domain.User (User(..), UserType)

type InputUserType =
  { firstName :: String
  , lastName :: String
  }

newtype CUser = CUser User

instance readCUser :: ReadForeign CUser where
  readImpl text = do
    (user :: UserType) <- (readImpl text)
    pure $ CUser (User user)

instance writeCUser :: WriteForeign CUser where
  writeImpl (CUser (User user)) = writeImpl user

instance showCUser :: Show CUser where
  show (CUser (User user)) =
    "User { id:" <> (toStringAs decimal (fromMaybe 0 user.id)) 
    <> ", firstName: '" <> user.firstName <> "'"
    <> ", lastName: '" <> user.lastName <> "' }"


fromInputRecord :: InputUserType -> CUser
fromInputRecord obj = do
  let obj' = build (merge { id: Nothing :: Maybe Int }) obj
  CUser (User obj')
