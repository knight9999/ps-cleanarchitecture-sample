module Infrastructure.Router
  ( init
  ) where

import Prelude
import Effect (Effect)
import Effect.Console (log, error)
import Control.Monad.Reader (ask)
import Effect.Class (liftEffect)
import Data.Maybe (Maybe(..))

import Bucketchain (createServer, listen)
import Bucketchain.Middleware (Middleware)
import Bucketchain.Http (requestMethod, requestURL, requestBody, setStatusCode, setHeader)
import Bucketchain.ResponseBody (body, fromReadable)

import Node.HTTP (ListenOptions, Server)

init :: Effect Unit
init = do
  s <- createServer middleware
  listen serverOpts s

middleware :: Middleware
middleware = getUsers <<< getUser <<< postUsers <<< welcome <<< error404

getUsers :: Middleware
getUsers next = do
  http <- ask
  if requestMethod http == "GET" && requestURL http == "/users"
    then liftEffect do
      setStatusCode http 200
      setHeader http "Content-Type" "text/json; charset=utf-8"
      Just <$> body "{ \"result\" : \"ok\" }\n"
    else next

getUser :: Middleware
getUser next = do
  http <- ask
  if requestMethod http == "GET" && requestURL http == "/user/:id"
    then liftEffect do
      setStatusCode http 200
      setHeader http "Content-Type" "text/plain; charset=utf-8"
      Just <$> body ""
    else next

postUsers :: Middleware
postUsers next = do
  http <- ask
  if requestMethod http == "POST" && requestURL http == "/users"
    then liftEffect do
      setStatusCode http 200
      setHeader http "Content-Type" "text/json; charset=utf-8"
      Just <$> body "{ \"result\" : \"ok\" }"
    else next

welcome :: Middleware
welcome next = do
  http <- ask
  if requestMethod http == "GET" && requestURL http == "/"
    then liftEffect do
      setStatusCode http 404
      setHeader http "Content-Type" "text/plain; charset=utf-8"
      Just <$> body "Welcome to PureScript Clean Architecture Page"
    else next

error404 :: Middleware
error404 next = do
  http <- ask
  liftEffect do
    setStatusCode http 404
    setHeader http "Content-Type" "text/plain; charset=utf-8"
    Just <$> body "Sorry, that page is not found"


serverOpts :: ListenOptions
serverOpts =
  { hostname: "localhost"
  , port: 3000
  , backlog: Nothing
  }


