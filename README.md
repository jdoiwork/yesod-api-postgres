# hello-yesod-api

```haskell
Example [Yesod, Json, Postgresql]
```

## Run DB Server

```bash
cd dev
docker compose up -d
```

Open http://localhost:5050

| Key      | Value                 |
| -------- | --------------------- |
| username | `pgadmin@example.com` |
| password | `password`            |



### Create users table


```sql
CREATE TABLE users (
    id serial PRIMARY KEY,
    name VARCHAR (50) UNIQUE NOT NULL,
);
```

## Run Web Server

```bash
cp example.env .env

stack run
```
