module Interfaces.Database.UserRepository
  ( mkUserRepository
  ) where

import Prelude
import Data.Maybe
import Data.Array ((!!))
import Effect.Aff (Aff)

import Domain.User (User(..))
import Usecase.UserRepository (UserRepositoryType)
import Interfaces.Database.DUser (DUser (..))
import Interfaces.Database.SqlHandler (SqlHandlerType)

mkUserRepository :: SqlHandlerType DUser -> UserRepositoryType
mkUserRepository sqlHandler = {
  userById: \i -> userById sqlHandler i
, users: users sqlHandler
, addUser: \user -> addUser sqlHandler user
}

userById :: (SqlHandlerType DUser) -> Int -> Aff (Maybe User)
userById sqlHandler id = do
  let queryString = "SELECT id, firstName, lastName FROM users WHERE id = $id;"
      params = { "$id": id }
  results <- sqlHandler.query queryString params 
  pure $ case results !! 0 of
    Just (DUser user) -> Just user
    Nothing -> Nothing

users :: (SqlHandlerType DUser) -> Aff (Array User)
users sqlHandler = do
  let queryString = "SELECT id, firstName, lastName FROM users;"
  users <- sqlHandler.query queryString { }
  pure $ ((\(DUser user) -> user) <$> users)

addUser :: (SqlHandlerType DUser) -> User -> Aff Unit
addUser sqlHandler (User record) = do
  let queryString = """
INSERT INTO users 
 ( firstName, lastName )
 VALUES
 ( $firstName, $lastName );
"""
      params = { "$firstName": record.firstName
               , "$lastName": record.lastName }
  _ <- sqlHandler.execute queryString params 
  pure unit

