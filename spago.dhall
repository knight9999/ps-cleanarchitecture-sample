{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "my-project"
, dependencies =
  [ "bucketchain"
  , "console"
  , "effect"
  , "node-fs"
  , "node-path"
  , "node-process"
  , "node-sqlite3"
  , "psci-support"
  , "record"
  , "simple-json"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
