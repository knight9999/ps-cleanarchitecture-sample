module Interfaces.Database.UserRepository
  ( find
  ) where

import Control.Monad

import Interfaces.Database.SqlHandler
import Domain.User (User)

-- find :: forall ds m. (SqlHandler ds m User) => Int -> ds -> m (Array User)
-- find id ds = do
--   let 
--     queryString = "SELECT id, firstName, lastName FROM users WHERE id = $id"
--     params = { "$id": id }
--   query queryString params ds

find :: forall repr result. (Monad repr) => 
          (SqlHandler repr result) => Int -> repr (Array result)
find id = do
  let 
    queryString = "SELECT id, firstName, lastName FROM users WHERE id = $id"
    params = { "$id": id }
  query queryString params
