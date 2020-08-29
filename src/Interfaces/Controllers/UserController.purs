module Interfaces.Controllers.UserController
  where

import Prelude
import Effect.Aff (Aff)
import Data.Maybe

import Domain.User

import Interfaces.Database.SqlHandler

import Interfaces.Database.UserRepository
import Usecase.UserInteractor

type UserControllerType = {
  create :: User -> Aff Unit
, index :: Aff (Array User)
, show :: Int -> Aff (Maybe User)
}

mkUserController :: SqlHandlerType User -> UserControllerType
mkUserController sqlHandler = {
  create: \user -> userInteractor.addUser user
, index: userInteractor.users
, show: \id -> userInteractor.userById id
} where
  userInteractor = mkUserInteractor $ mkUserRepository sqlHandler
  