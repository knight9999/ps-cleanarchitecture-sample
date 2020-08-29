module Usecase.UserInteractor
  (
    UserInteractorType
  , mkUserInteractor
  ) where

import Prelude
import Data.Maybe (Maybe)
import Effect.Aff (Aff)

import Domain.User (User)
import Usecase.UserRepository

type UserInteractorType = {
  userById :: Int -> Aff (Maybe User)
, users :: Aff (Array User)
, addUser :: User -> Aff Unit
}

mkUserInteractor :: UserRepositoryType -> UserInteractorType
mkUserInteractor userRepository = {
  userById: userRepository.userById
, users: userRepository.users
, addUser: userRepository.addUser
}