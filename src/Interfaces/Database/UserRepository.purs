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

import Usecase.UserRepository (UserRepositoryType)


mkUserRepository :: forall ds. (SqlHandler ds User) => ds -> UserRepositoryType
mkUserRepository ds = {
  userById: \i -> runReaderT (userById i) ds
, users: runReaderT users ds
, addUser: \user -> runReaderT (addUser user) ds
}

userById :: forall ds.  
          (SqlHandler ds User) => Int -> (ReaderT ds Aff) (Maybe User)
userById id = do
  let queryString = "SELECT id, firstName, lastName FROM users WHERE id = $id;"
      params = { "$id": id }
  results <- query queryString params :: (ReaderT ds Aff) (Array User)
  pure $ results !! 0  

users :: forall ds.  
          (SqlHandler ds User) => (ReaderT ds Aff) (Array User)
users = query queryString { }
  where 
    queryString = "SELECT id, firstName, lastName FROM users;"


addUser :: forall ds.
          (SqlHandler ds User) => User -> (ReaderT ds Aff) Unit
addUser (User record) = do
  let queryString = """
INSERT INTO users 
 ( firstName, lastName )
 VALUES
 ( $firstName, $lastName );
"""
      params = { "$firstName": record.firstName
               , "$lastName": record.lastName }
  _ <- query queryString params :: (ReaderT ds Aff) (Array User)
  pure unit