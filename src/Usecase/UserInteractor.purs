module Usecase.UserInteractor
  (
    UserInteractorType
  , mkUserInteractor
  ) where

import Prelude (Unit)
import Data.Maybe (Maybe)
import Effect.Aff (Aff)

import Domain.User (User)
import Usecase.UserRepository (UserRepositoryType)

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