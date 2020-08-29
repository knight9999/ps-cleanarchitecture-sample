module Interfaces.Database.UserRepository
  ( findUserById
  ) where

import Control.Monad

import Interfaces.Database.SqlHandler
import Domain.User (User)

-- type UserRepositoryType = {
--   getUser :: Int -> Aff (Array User)
-- }

findUserById :: forall repr. (Monad repr) => 
          (SqlHandler repr User) => Int -> repr (Array User)
findUserById id = findById id


findById :: forall repr result. (Monad repr) => 
          (SqlHandler repr result) => Int -> repr (Array result)
findById id = do
  let 
    queryString = "SELECT id, firstName, lastName FROM users WHERE id = $id"
    params = { "$id": id }
  query queryString params
