module Main where

import Prelude (Unit, bind, discard, pure, unit, ($))

import Effect (Effect)
import Effect.Console (error)
import Effect.Exception (error, throwException) as EE

import Node.Globals as NG
import Node.Path as NP
import Node.FS.Sync as NFS

import Infrastructure.Router as Router

main :: Effect Unit
main = do

  -- check DB
  let dbFile = NP.concat [NG.__dirname, "..", "db", "db.sqlite3"]
  isExist <- NFS.exists dbFile
  if isExist
    then 
      pure unit
    else do
      error "No db.sqlite3 file"
      EE.throwException $ EE.error "No db.sqlite3 file"

  Router.init dbFile
