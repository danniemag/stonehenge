# Stonehenge

An Elixir API REST Bank.
This code implements an API bank application in Elixir/Phoenix including sign_in/sign_out for study purposes.

_____________________
To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000).

### DO NOT FORGET:
  Seed database by running command
  ```sh
    mix run priv/repo/seeds.exs
  ```
  It contains main system user - the only allowed to access `/backoffice` endpoint.

  *SUPERUSER*
  ```
  Email: admin@stonehenge.com 
  Pwd: Rock2019*
  ```

  *COMMON USERS*
  ```
  Email: lorem@ipsum.com 
  Email: stark@ipsum.com 
  Pwd: abc123
  ```
____________________________

### Add-ons
- Bcrypt-Elixir [https://hex.pm/packages/bcrypt_elixir]
- Timex [https://hex.pm/packages/timex]

_________________

### Available Endpoints

| HTTP METHOD | PATH   | USAGE  |
| ----------- | ------ | ------ |
|   POST      |  /api/users/sign_in     | Signs in previously registered user                                   |
|   POST      |  /api/users/sign_out    | Signs out any logged user                                             |
|   GET       |  /api/users             | When logged, returns all users                                        |
|   GET       |  /api/users/:id         | When logged, returns a specific user by id                            |
|   GET       |  /api/users/balance     | When logged, returns current user account balance                     |
|   PUT       |  /api/users/withdrawal  | When logged, performs a withdrawal operation in current user's account|
|   PUT       |  /api/users/transfer    | When logged, performs a transfer operation in current user's account  |
|   GET       |  /api/backoffice        | When superuser is logged, returns all users' operation amounts by credits and debits, organized per current day, current month and current year                                                                                          |
|   GET       |  /api/histories         | When superuser is logged, returns a list of all users operations of all time|

_________________

### HTTP Statuses
- 200 OK: The request has succeeded
- 400 Bad Request: The request could not be understood by the server 
- 404 Not Found: The requested resource cannot be found
- 500 Internal Server Error: The server encountered an unexpected condition 
_________________

# Endpoints

## /api/users/sign_in

##### How to test:
```sh
curl -H "Content-Type: application/json" -X POST -d '{"email":"lorem@ipsum.com","password":"abc123"}' http://localhost:4000/api/users/sign_in -c cookies.txt -b cookies.txt -i
```
##### Success response:
```sh
{
  "data":
    {
      "user":
        {
          "email":"lorem@ipsum.com",
          "id":2
        }
    }
}
```
##### Error response (wrong_credentials error):
```sh
{
  "errors":
    {"detail":"Wrong email or password"}
}
```
___
## /api/users/sign_out

##### How to test:
```sh
curl -H "Content-Type: application/json" -X POST http://localhost:4000/api/users/sign_out -c cookies.txt -b cookies.txt -i
```
##### Success response:
```sh
{"message":"Successfully logged out"}
```
___
## /api/users

##### How to test:
```sh
curl -H "Content-Type: application/json" -X GET http://localhost:4000/api/users/ -c cookies.txt -b cookies.txt -i
```
##### Success response:
```sh
{
  "data":
  [
    { "balance":20.0,
      "email":"admin@stonehenge.com",
      "id":1,
      "is_active":false
    },{
      "balance":970.0,
      "email":"lorem@ipsum.com",
      "id":2,
      "is_active":false
    }
  ]
}
```
##### Error response (not_superuser error):
```sh
{
  "errors":
    {"detail":"No permission to access this resouce"}
}
```
___
## /api/users/balance

##### How to test:
```sh
curl -H "Content-Type: application/json" -X GET http://localhost:4000/api/users/balance -c cookies.txt -b cookies.txt -i
```
##### Success response:
```sh
{
  "data":
  { "current_balance":900.0,
    "current_user_email":"lorem@ipsum.com",
    "current_user_id":2
  }
} 
```
##### Error response (unauthenticated error):
```sh
{
  "errors":
    {"detail":"Unauthenticated user"}
}
```
___
## /api/users/withdrawal

##### How to test:
```sh
curl -H "Content-Type: application/json" -X PUT -d '{"value": 30}' http://localhost:4000/api/users/withdrawal -c cookies.txt -b cookies.txt -i
```
##### Success response:
```sh
{
  "data":
    { "current_balance":970.0,
      "current_user_id":2,
      "user_email":"lorem@ipsum.com"
    }
}
```
##### Error response (insufficient_balance error):
```sh
{
  "errors":
    {"detail":"Insufficient balance to perform this operation"}
}
```
___
## /api/users/transfer

##### How to test:
```sh
curl -H "Content-Type: application/json" -X PUT -d '{"value": 20, "email": "admin@stonehenge.com"}' http://localhost:4000/api/users/transfer -c cookies.txt -b cookies.txt -i
```
##### Success response:
```sh
{
  "data":
    {
      "current_balance":980.0,
      "debit_account":"lorem@ipsum.com",
      "destination_account":"admin@stonehenge.com",
      "transferred_amount":20.0
    }
}
```
##### Error response (no_balance error):
```sh
{
  "errors":
    {
      "detail":"Insufficient balance to perform this operation"
    }
}
```
##### Error response (receiver_not_found error):
```sh
{
  "errors":
    {
      "detail":"Destination account not found"
    }
}
```
___
## /api/backoffice

##### How to test:
```sh
curl -H "Content-Type: application/json" -X GET http://localhost:4000/api/backoffice/ -c cookies.txt -b cookies.txt -i
```
##### Success response:
```sh
{
  "data":
    {
      "current_day":
        {
          "credit_sum":[20.0],
          "debit_sum":[-20.0]
        },
      "current_month":
        {
          "credit_sum":[20.0],
          "debit_sum":[-20.0]
        },
      "current_year":
        {
          "credit_sum":[20.0],
          "debit_sum":[-20.0]
        }
    }
}
```
##### Error response (not_superuser error):
```sh
{
  "errors":
    {"detail":"No permission to access this resouce"}
}
```
___
## /api/histories

##### How to test:
```sh
curl -H "Content-Type: application/json" -X POST -d '{"email":"lorem@ipsum.com","password":"abc123"}' http://localhost:4000/api/users/sign_in -c cookies.txt -b cookies.txt -i
```
##### Success response:
```sh
{
  "data":[
    {
      "created_at":"2019-06-24T17:48:55",
      "destination_account":"admin@stonehenge.com",
      "id":1,
      "operation_type":"credit",
      "origin_account":"lorem@ipsum.com",
      "value":10.0
    },{
      "created_at":"2019-06-24T17:51:51",
      "destination_account":null,
      "id":2,
      "operation_type":"debit",
      "origin_account":"lorem@ipsum.com",
      "value":-10.0
    },{
      "created_at":"2019-06-24T17:51:51",
      "destination_account":"admin@stonehenge.com",
      "id":3,
      "operation_type":"credit",
      "origin_account":"lorem@ipsum.com",
      "value":10.0
    },{
      "created_at":"2019-06-24T18:00:40",
      "destination_account":null,
      "id":4,
      "operation_type":"debit",
      "origin_account":"lorem@ipsum.com",
      "value":-10.0
    },{
      "created_at":"2019-06-24T21:53:01",
      "destination_account":null,
      "id":5,
      "operation_type":"debit",
      "origin_account":"lorem@ipsum.com",
      "value":-70.0
    }
  ]
}
```
##### Error response (not_superuser error):
```sh
{
  "errors":
    {"detail":"No permission to access this resouce"}
}
```
___

## SHAME WALL

- Although deploy has succeeded (three times!) at Heroku, some problem with database there prevents application from being used (`https://boiling-eyrie-62083.herokuapp.com/api/`). Shame on you, Heroku!

- I spent three days ~fighting against~ trying to implement auth via Guardian, but we didn't become best friends yet, that's why I threw everything away, started from zero and implemented manual authentication. The problem is: time to implement more specs is over now... :(
