# How to Install

```
% npm install
% npx spago install
% npm run build
```


# Start Application

## Create Database

```
% sqlite3 db/db.sqlite3 < sql/make_db.sql
```

The `db` directory must be on the same directory level as `dist` diretory.

## Start App

```
% npm run server
```


# Supplement (Initial Settings)

```
% npm init -y
% npm install -D spago purescript
% npx spago init
% npm install sqlite3
% npx spago install node-process node-sqlite3 simple-json bucketchain
```


# Test Curl Command

## List All

```
% curl -i -H 'Content-Type:application/json' localhost:3000/users
```

## List Specified

```
% curl -i -H 'Content-Type:application/json' localhost:3000/users/3
```

## Add User

```
% curl -i -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"firstName": "Hello", "lastName": "PureScript"}' localhost:3000/users
```


# References

https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html

Clean Architecture Sample (Go Lang)
https://qiita.com/hirotakan/items/698c1f5773a3cca6193e


