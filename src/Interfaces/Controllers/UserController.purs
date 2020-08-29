module Interfaces.Controllers.UserController
  where

import Prelude
import Domain.User

type UserControllerType = {
  create :: UserType -> UserType
, index :: Array UserType
, show :: Int -> UserType
}

-- mkUserController :: SqlHandler -> UserControllerType
-- mkUserController sqlHandler = do
  