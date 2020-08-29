module Infrastructure.Router
  ( init
  ) where

import Prelude
import Effect (Effect)
import Effect.Console (log, error)
import Control.Monad.Reader (ask)
import Effect.Class (liftEffect)
import Data.Maybe 
import Effect.Aff (launchAff_)
import Effect.Aff.Class (liftAff)
import Data.Foldable (for_)
import Simple.JSON

import Bucketchain (createServer, listen)
import Bucketchain.Middleware (Middleware)
import Bucketchain.Http (requestMethod, requestURL, requestBody, setStatusCode, setHeader)
import Bucketchain.ResponseBody (body, fromReadable)
import Node.HTTP (ListenOptions, Server)
import SQLite3 (DBConnection, closeDB, newDB, queryDB, queryObjectDB)

import Infrastructure.SqlHandler as SH
import Interfaces.Controllers.UserController as ICU

init :: String -> Effect Unit
init dbFile = do
  s <- createServer $ middleware dbFile
  listen serverOpts s

middleware :: String -> Middleware
middleware dbFile 
  =   (getUsers dbFile)
  <<< (getUser dbFile)
  <<< (postUsers dbFile) 
  <<< welcome <<< error404

getUsers :: String -> Middleware
getUsers dbFile next = do
  http <- ask
  if requestMethod http == "GET" && requestURL http == "/users"
    then do
      users <- liftAff do
        db <- newDB dbFile
        let sqlHandler = SH.mkSqlHandler (SH.DataStore { conn: db })
        let userController = ICU.mkUserController sqlHandler
        users <- userController.index
        closeDB db
        pure users
      liftEffect do
        let resBody = writeJSON users
        setStatusCode http 200
        setHeader http "Content-Type" "text/json; charset=utf-8"
        Just <$> body (resBody <> "\n")
    else next

getUser :: String -> Middleware
getUser dbFile next = do
  http <- ask
  if requestMethod http == "GET" && requestURL http == "/user/:id"
    then liftEffect do
      setStatusCode http 200
      setHeader http "Content-Type" "text/plain; charset=utf-8"
      Just <$> body ""
    else next

postUsers :: String -> Middleware
postUsers dbFile next = do
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


