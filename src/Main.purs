module Main where

import Prelude

import Effect (Effect)
import Effect.Console (log, error)
import Effect.Aff.Class (liftAff)
import Effect.Class (liftEffect)
import Control.Monad.Error.Class (throwError)
import Control.Monad.Reader (ask)
import Data.Maybe (Maybe(..))
import Data.Either
import Data.Options ((:=))
import Effect.Exception (error, throwException) as EE

import Node.HTTP (ListenOptions, Server)
import Node.HTTP.Client as C

import Bucketchain (createServer, listen)
import Bucketchain.Middleware (Middleware)
import Bucketchain.Http (requestMethod, requestURL, requestBody, setStatusCode, setHeader)
import Bucketchain.ResponseBody (body, fromReadable)

import Node.Globals as NG
import Node.Path as NP
import Node.FS.Sync as NFS


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

  -- check DB
  let dbDir = NP.concat [NG.__dirname, "..", "db"]
  isExist <- NFS.exists dbDir
  isReadyDB <- 
    if isExist
    then do
      let sqlFile = NP.concat [dbDir, "db.sqlite3"]
      isExist' <- NFS.exists sqlFile
      if isExist'
        then
          pure true
        else
          pure false
    else
      pure false
  if isReadyDB 
    then 
      pure unit
    else do
      error "No db.sqlite3 file"
      EE.throwException $ EE.error "No db.sqlite3 file"

  -- start server
  s <- createServer middleware
  listen serverOpts s



