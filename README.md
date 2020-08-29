

# Create Database

```
% sqlite3 db/db.sqlite3 < sql/make_db.sql
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
curl -i -H 'Content-Type:application/json' localhost:3000/users
```

## List Specified

```
curl -i -H 'Content-Type:application/json' localhost:3000/users/3
```

## Add User

$ curl -i -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"firstName": "Susan", "lastName": "Taylor"}' localhost:3000/users


