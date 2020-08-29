module Usecase.UserRepository
  ( UserRepositoryType
  ) where

import Prelude
import Data.Maybe (Maybe)
import Effect.Aff (Aff)

import Domain.User (User)

type UserRepositoryType = {
  userById :: Int -> Aff (Maybe User)
, users :: Aff (Array User)
, addUser :: User -> Aff Unit
}


