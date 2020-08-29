module Interfaces.Database.UserRepository
  ( mkUserRepository
  , findUserById
  , findById
  ) where

import Control.Monad
import Control.Monad.Reader.Trans
import Effect.Aff (Aff, launchAff)

import Interfaces.Database.SqlHandler
import Domain.User (User)

type UserRepositoryType = {
  findUserById :: Int -> Aff (Array User)
}

mkUserRepository :: forall ds. (SqlHandler ds User) => ds -> UserRepositoryType
mkUserRepository ds = {
  findUserById: \i -> runReaderT (findUserById i) ds
}

findUserById :: forall ds.
          (SqlHandler ds User) => Int -> (ReaderT ds Aff) (Array User)
findUserById id = findById id


findById :: forall ds result.  
          (SqlHandler ds result) => Int -> (ReaderT ds Aff) (Array result)
findById id = query queryString params
  where 
    queryString = "SELECT id, firstName, lastName FROM users WHERE id = $id"
    params = { "$id": id }
  
