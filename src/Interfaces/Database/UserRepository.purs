module Interfaces.Database.UserRepository
  ( mkUserRepository
  ) where

import Prelude (Unit, bind, pure, unit, ($))
import Data.Maybe (Maybe)
import Data.Array ((!!))
import Effect.Aff (Aff)

import Domain.User (User(..))
import Interfaces.Database.SqlHandler (SqlHandlerType)
import Usecase.UserRepository (UserRepositoryType)

mkUserRepository :: SqlHandlerType User -> UserRepositoryType
mkUserRepository sqlHandler = {
  userById: \i -> userById sqlHandler i
, users: users sqlHandler
, addUser: \user -> addUser sqlHandler user
}

userById :: (SqlHandlerType User) -> Int -> Aff (Maybe User)
userById sqlHandler id = do
  let queryString = "SELECT id, firstName, lastName FROM users WHERE id = $id;"
      params = { "$id": id }
  results <- sqlHandler.query queryString params 
  pure $ results !! 0  

users :: (SqlHandlerType User) -> Aff (Array User)
users sqlHandler = sqlHandler.query queryString { }
  where 
    queryString = "SELECT id, firstName, lastName FROM users;"


addUser :: (SqlHandlerType User) -> User -> Aff Unit
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

