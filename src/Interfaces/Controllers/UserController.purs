module Interfaces.Controllers.UserController
  where

import Prelude (Unit, ($))
import Effect.Aff (Aff)
import Data.Maybe (Maybe)

import Domain.User (User)

import Interfaces.Database.SqlHandler (SqlHandlerType)

import Interfaces.Database.UserRepository (mkUserRepository)
import Usecase.UserInteractor (mkUserInteractor)

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
  