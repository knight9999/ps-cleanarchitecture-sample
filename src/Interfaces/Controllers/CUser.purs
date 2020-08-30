module Interfaces.Controllers.CUser
  ( CUser(..)
  , fromObj
  ) where

import Prelude (class Show, bind, pure, ($), (<>))
import Simple.JSON (class ReadForeign, readImpl, class WriteForeign, writeImpl)
import Data.Int (decimal, toStringAs)
import Data.Maybe
import Foreign
import Record.Builder (build, merge)
import Control.Monad.Except
import Effect.Exception
import Data.Function

import Domain.User

newtype CUser = CUser User

-- newtype CUser' = CUser' CUser

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


fromObj :: UnregisteredUserType -> CUser
fromObj obj = do
  let obj' = build (merge { id: Nothing :: Maybe Int }) obj
  CUser (User obj')
