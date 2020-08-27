module Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)
import Effect.Aff.Class (liftAff)
import Effect.Class (liftEffect)
import Control.Monad.Error.Class (throwError)
import Control.Monad.Reader (ask)
import Data.Maybe (Maybe(..))
import Data.Either
import Data.Options ((:=))

import Node.HTTP (ListenOptions, Server)
import Node.HTTP.Client as C

import Bucketchain (createServer, listen)
import Bucketchain.Middleware (Middleware)
import Bucketchain.Http (requestMethod, requestURL, requestBody, setStatusCode, setHeader)
import Bucketchain.ResponseBody (body, fromReadable)

middleware :: Middleware
middleware next = do
  http <- ask
  if requestMethod http == "GET" && requestURL http == "/test"
    then liftEffect do
      setStatusCode http 200
      setHeader http "Content-Type" "text/plain; charset=utf-8"
      Just <$> body "Hello PureScript :)"
    else next

serverOpts :: ListenOptions
serverOpts =
  { hostname: "localhost"
  , port: 3000
  , backlog: Nothing
  }

main :: Effect Unit
main = do
  s <- createServer middleware
  listen serverOpts s
