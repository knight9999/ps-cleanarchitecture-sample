module Interfaces.Database.UserRepository
  ( findUserById
  ) where

import Control.Monad
import Control.Monad.Reader.Trans
import Effect.Aff (Aff, launchAff)

import Interfaces.Database.SqlHandler
import Domain.User (User)

-- type UserRepositoryType = {
--   getUser :: Int -> Aff (Array User)
-- }

findUserById :: forall ds.
          (SqlHandler ds User) => Int -> (ReaderT ds Aff) (Array User)
findUserById id = findById id


findById :: forall ds result.  
          (SqlHandler ds result) => Int -> (ReaderT ds Aff) (Array result)
findById id = do
  let 
    queryString = "SELECT id, firstName, lastName FROM users WHERE id = $id"
    params = { "$id": id }
  query queryString params
