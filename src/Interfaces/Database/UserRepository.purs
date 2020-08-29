module Interfaces.Database.UserRepository
  ( mkUserRepository
  ) where

import Prelude
import Data.Maybe (Maybe)
import Data.Array

import Control.Monad
import Control.Monad.Reader.Trans
import Effect.Aff (Aff, launchAff)

import Interfaces.Database.SqlHandler
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


-- mkUserRepository :: forall ds. (SqlHandler ds User) => ds -> UserRepositoryType
-- mkUserRepository ds = {
--   userById: \i -> runReaderT (userById i) ds
-- , users: runReaderT users ds
-- , addUser: \user -> runReaderT (addUser user) ds
-- }

-- userById :: forall ds.  
--           (SqlHandler ds User) => Int -> (ReaderT ds Aff) (Maybe User)
-- userById id = do
--   let queryString = "SELECT id, firstName, lastName FROM users WHERE id = $id;"
--       params = { "$id": id }
--   results <- query queryString params 
--   pure $ results !! 0  
