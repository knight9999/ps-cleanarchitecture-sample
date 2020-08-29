module Interfaces.Database.UserRepository
  ( mkUserRepository
  , findById
  ) where

import Prelude
import Data.Maybe (Maybe)
import Data.Array

import Control.Monad
import Control.Monad.Reader.Trans
import Effect.Aff (Aff, launchAff)

import Interfaces.Database.SqlHandler
import Domain.User (User)

import Usecase.UserRepository (UserRepositoryType)


mkUserRepository :: forall ds. (SqlHandler ds User) => ds -> UserRepositoryType
mkUserRepository ds = {
  userById: \i -> runReaderT (userById i) ds
, users: runReaderT (users) ds
}

userById :: forall ds.
          (SqlHandler ds User) => Int -> (ReaderT ds Aff) (Maybe User)
userById id = findById id

users :: forall ds.
          (SqlHandler ds User) => (ReaderT ds Aff) (Array User)
users = findAll


findById :: forall ds result.  
          (SqlHandler ds result) => Int -> (ReaderT ds Aff) (Maybe result)
findById id = do
  let queryString = "SELECT id, firstName, lastName FROM users WHERE id = $id"
      params = { "$id": id }
  results <- query queryString params :: (ReaderT ds Aff) (Array result)
  pure $ results !! 0  

findAll :: forall ds result.  
          (SqlHandler ds result) => (ReaderT ds Aff) (Array result)
findAll = query queryString { }
  where 
    queryString = "SELECT id, firstName, lastName FROM users"
