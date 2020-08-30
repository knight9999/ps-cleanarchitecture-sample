module Infrastructure.Router
  ( init
  ) where

import Prelude (Unit, bind, discard, join, pure, ($), (&&), (<$>), (<<<), (<>), (==))
import Effect (Effect)
import Effect.Console (log)
import Control.Monad.Reader (ask)
import Effect.Class (liftEffect)
import Data.Maybe (Maybe(..))
import Data.Either (Either(..))
import Data.Int (fromString)
import Effect.Aff.Class (liftAff)
import Simple.JSON (readJSON, writeJSON, read, E)
import Data.String.Regex as Regex
import Data.String.Regex.Flags (noFlags)
import Data.Array.NonEmpty as NonEmptyArray
import Record.Builder (build, merge)
import Foreign.Object (lookup)
import Foreign (Foreign, MultipleErrors, unsafeToForeign)

import Bucketchain (createServer, listen)
import Bucketchain.Middleware (Middleware)
import Bucketchain.Http (requestMethod, requestURL, requestBody, setStatusCode, setHeader, requestHeaders)
import Bucketchain.ResponseBody (body)
import Node.HTTP (ListenOptions)
import SQLite3 (closeDB, newDB)

import Infrastructure.SqlHandler as SH
import Interfaces.Controllers.UserController as ICU

import Interfaces.Controllers.CUser as CUser

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
  if requestMethod http == "GET"
    then case (Regex.regex "^/users/(\\d+)$" noFlags) of
      Left error -> next
      Right regex ->
        case Regex.match regex (requestURL http) of
          Just list -> do
            case join $ fromString <$> (join $ (NonEmptyArray.index) list 1) of
              Just userid -> do
                user_ <- liftAff do
                  db <- newDB dbFile
                  let sqlHandler = SH.mkSqlHandler (SH.DataStore { conn: db })
                  let userController = ICU.mkUserController sqlHandler
                  user <- userController.show userid
                  closeDB db
                  pure user
                case user_ of
                  Just user -> liftEffect do
                    let resBody = writeJSON user
                    setStatusCode http 200
                    setHeader http "Content-Type" "text/plain; charset=utf-8"
                    Just <$> body (resBody <> "\n")
                  Nothing -> (error404 next)
              Nothing -> next
          Nothing -> next
    else next

postUsers :: String -> Middleware
postUsers dbFile next = do
  http <- ask
  if requestMethod http == "POST" && requestURL http == "/users"
    then do
      result <- liftAff do
        reqBody <- requestBody http
        case (readJSON reqBody :: Either MultipleErrors { firstName :: String, lastName :: String }) of
          Left error -> pure $ Left "ERROR"
          Right obj -> do
            db <- newDB dbFile
            let sqlHandler = SH.mkSqlHandler (SH.DataStore { conn: db })
            let userController = ICU.mkUserController sqlHandler
            userController.create (CUser.fromObj obj)
            closeDB db
            pure $ Right "OK"
      case result of
        Left _ -> (error503 next)
        Right _ -> liftEffect do
          setStatusCode http 200
          setHeader http "Content-Type" "text/json; charset=utf-8"
          Just <$> body (writeJSON { "result" : "ok" } <> "\n")
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
  let obj = requestHeaders http
  case lookup "content-type" obj of 
    Just contentType -> liftEffect do
        setStatusCode http 404
        setHeader http "Content-Type" "application/json; charset=utf-8"
        Just <$> body (writeJSON { "result" : "Not Found" } <> "\n")
    Nothing -> liftEffect do
        setStatusCode http 404
        setHeader http "Content-Type" "text/plain; charset=utf-8"
        Just <$> body ("Sorry!!, that page is not found\n")

error503 :: Middleware
error503 next = do
  http <- ask
  let obj = requestHeaders http
  case lookup "content-type" obj of 
    Just contentType -> liftEffect do
        setStatusCode http 503
        setHeader http "Content-Type" "application/json; charset=utf-8"
        Just <$> body (writeJSON { "result" : "Internal Error" } <> "\n")
    Nothing -> liftEffect do
        setStatusCode http 503
        setHeader http "Content-Type" "text/plain; charset=utf-8"
        Just <$> body ("Sorry!!, Internal Error happens\n")


serverOpts :: ListenOptions
serverOpts =
  { hostname: "localhost"
  , port: 3000
  , backlog: Nothing
  }


