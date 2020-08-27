module Interfaces.Database.UserRepository
  ( store
  )
  where

import Effect.Aff (Aff)

import Interfaces.Database.SqlHandler
import Domain.User (User)

store :: forall ds. (SqlHandler ds User) => User -> ds -> Aff (Array User)
store user ds = do
  let 
    queryString = "SELECT id, firstName, lastName FROM users WHERE id = $id"
    params = { "$id": 4 }
  query queryString params ds
