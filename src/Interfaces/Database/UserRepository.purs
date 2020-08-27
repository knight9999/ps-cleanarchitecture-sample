module Interfaces.Database.UserRepository
  ( find
  )
  where

import Effect.Aff (Aff)

import Interfaces.Database.SqlHandler
import Domain.User (User)

find :: forall ds m. (SqlHandler ds m User) => Int -> ds -> m (Array User)
find id ds = do
  let 
    queryString = "SELECT id, firstName, lastName FROM users WHERE id = $id"
    params = { "$id": id }
  query queryString params ds
