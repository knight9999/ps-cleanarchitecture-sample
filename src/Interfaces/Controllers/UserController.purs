module Interfaces.Controllers.UserController
  where

import Prelude (Unit, map, ($), (<$>))
import Effect.Aff (Aff)
import Data.Maybe (Maybe)

import Domain.User (User)
import Usecase.UserInteractor (mkUserInteractor)

import Interfaces.Controllers.CUser (CUser(..))
import Interfaces.Database.DUser
import Interfaces.Database.SqlHandler (SqlHandlerType)
import Interfaces.Database.UserRepository (mkUserRepository)

type UserControllerType = {
  create :: User -> Aff Unit
, index :: Aff (Array CUser)
, show :: Int -> Aff (Maybe CUser)
}

mkUserController :: SqlHandlerType DUser -> UserControllerType
mkUserController sqlHandler = {
  create: userInteractor.addUser
, index: map (\user -> CUser user) <$> userInteractor.users
, show: \id -> map (\user -> CUser user) <$> (userInteractor.userById id)
} where
  userInteractor = mkUserInteractor $ mkUserRepository sqlHandler
  