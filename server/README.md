# scanningworld server

A server for a scanningworld app and its admin dashboard. Created using NestJS.

# Demo

https://scanningworld-server.herokuapp.com/

# Installation

```bash
  git clone https://github.com/gonciuu/scanningworld
  cd scanningworld
  cd server
  npm i
```

**_Don't forget to create your .env file with contents of .env.example file_**

# API Reference

## Table of contents

- [Auth module](#auth-module)
- [Users module](#users-module)
- [Regions module](#regions-module)
- [Places module](#places-module)
- [Coupons module](#coupons-module)

## The dependency of the modules

![Dependecy of modules](https://i.imgur.com/cQUoKpV.png)

## Auth module

This module is for logging/registering/refreshing tokens for user and admins of regions.

Typically you will pass access token to basically all request you will make. If the access token has expired the server will return 401 Unauthorized error and you should refresh the access with your refresh token and call the request again. The refresh request can return 403 Forbidden error - it means that the user should be logged out.

### `Register user`

```
  POST /auth/register
```

#### Request body

| Parameter  | Type     | Description                           |
| :--------- | :------- | :------------------------------------ |
| `name`     | `string` | **Required**. User name.              |
| `email`    | `string` | **Required**. User email.             |
| `password` | `string` | **Required**. User password to login. |
| `phone`    | `string` | **Required**. User phone to login.    |
| `regionId` | `string` | **Required**. User region id.         |

#### Response

    {
        "tokens": {
            "accessToken": "accessToken",
            "refreshToken": "refreshToken"
        },
        "user": {
            "name": "Bruno Dzięcielski",
            "email": "brunodzi07@gmail.com",
            "phone": "123321123",
            "region": {
                "_id": "63485005b9a6f084791d694a",
                "name": "Gorzyce",
                "placeCount": 0,
                "email": "gokgorzyce@gorzyce.pl",
                "__v": 0
            },
            "scannedPlaces": [],
            "_id": "634c51d99c60289b62cdded9",
            "activeCoupons": [],
            "avatar": "male3"
            "__v": 0
        }
    }

### `Register region`

```
  POST /auth/region/register
```

#### Request body

| Parameter  | Type     | Description                             |
| :--------- | :------- | :-------------------------------------- |
| `name`     | `string` | **Required**. Region name.              |
| `email`    | `string` | **Required**. Region email.             |
| `password` | `string` | **Required**. Region password to login. |

#### Response

    {
        "tokens": {
            "accessToken": "access-region-token",
            "refreshToken": "refresh-token"
        },
        "region": {
            "name": "Gorzyce",
            "placeCount": 0,
            "email": "gokgorzyce@gorzyce.pl",
            "_id": "6351810d396297886a972501",
            "__v": 0
        }
    }

### `Login user`

```
  POST /auth/login
```

#### Request body

| Parameter  | Type     | Description                           |
| :--------- | :------- | :------------------------------------ |
| `phone`    | `string` | **Required**. User phone to login.    |
| `password` | `string` | **Required**. User password to login. |

#### Response

    {
        "tokens": {
            "accessToken": "accessToken",
            "refreshToken": "refreshToken"
        },
        "user": {
            "name": "Bruno Dzięcielski",
            "email": "brunodzi07@gmail.com",
            "phone": "123321123",
            "region": {
                "_id": "63485005b9a6f084791d694a",
                "name": "Gorzyce",
                "placeCount": 0,
                "email": "gokgorzyce@gorzyce.pl",
                "__v": 0
            },
            "scannedPlaces": [],
            "_id": "634c51d99c60289b62cdded9",
            "activeCoupons": [],
            "avatar": "male3"
            "__v": 0
        }
    }

### `Login admin region`

```
  POST /auth/region/login
```

#### Request body

| Parameter  | Type     | Description                             |
| :--------- | :------- | :-------------------------------------- |
| `email`    | `string` | **Required**. Region email to login.    |
| `password` | `string` | **Required**. Region password to login. |

#### Response

    {
        "tokens": {
            "accessToken": "access-region-token",
            "refreshToken": "refresh-token"
        },
        "region": {
            "name": "Gorzyce",
            "placeCount": 0,
            "email": "gokgorzyce@gorzyce.pl",
            "_id": "6351810d396297886a972501",
            "__v": 0
        }
    }

### `Refresh user access token`

#### You need to pass refresh token as Authorization token.

```
  GET /auth/refresh
```

#### Response

    {
        "accessToken": "new-accessToken",
        "refreshToken": "new-refreshToken"
    }

### `Refresh region access token`

#### You need to pass refresh token as Authorization token.

```
  GET /auth/region/refresh
```

#### Response

    {
        "accessToken": "new-access-region-token",
        "refreshToken": "new-refreshToken"
    }

### `Logout user`

#### You need to pass user access token as Authorization token.

```
  GET /auth/logout
```

#### Response

    {
        "msg": "User logged out"
    }

### `Logout admin region`

#### You need to pass region access token as Authorization token.

```
  GET /auth/region/logout
```

#### Response

    {
        "msg": "Region logged out"
    }

### `Change user password`

#### You need to pass user access token as Authorization token.

```
  PATCH /auth/change-password
```

#### Request body

| Parameter     | Type     | Description                                |
| :------------ | :------- | :----------------------------------------- |
| `oldPassword` | `string` | **Required**. User old password.           |
| `newPassword` | `string` | **Required**. User new password to change. |

#### Response

    {
        "msg": "Password changed"
    }

TODO: Add forgot password documentation later

## Users module

### User object

| Field                | Type                                                           | Description                                            |
| :------------------- | :------------------------------------------------------------- | :----------------------------------------------------- |
| `name`               | `string`                                                       | User name.                                             |
| `email`              | `string`                                                       | User email.                                            |
| `phone`              | `string`                                                       | User phone number.                                     |
| `avatar`             | `string enum (male1, male2, male3, female1, female2, female3)` | User avatar.                                           |
| `region`             | `Region`                                                       | Region object that user belongs to.                    |
| `points`             | `[regiondId: string]: number`                                  | Array of user points per region.                       |
| `scannedPlaces`      | `Place[]`                                                      | Array of scanned places by user.                       |
| `activeCoupons`      | `{coupon: Coupon; validUntil: Date}[]`                         | Actived coupons by user.                               |
| `password`           | `string`                                                       | Hashed password (not selected by default).             |
| `refreshToken`       | `string`                                                       | Hashed refresh token (not selected by default).        |
| `passwordResetToken` | `string`                                                       | Hashed reset password token (not selected by default). |
| `_id`                | `ObjectId (string)`                                            | User id.                                               |

### `Get user details from user access token`

#### You need to pass user access token as Authorization token.

```
  GET /users/me
```

#### Response

    {
        "_id": "634c51d99c60289b62cdded9",
        "name": "Bruno Dzięcielski",
        "email": "brunodzi07@gmail.com",
        "phone": "123123122",
        "region": {
                "_id": "63485005b9a6f084791d694a",
                "name": "Gorzyce",
                "placeCount": 0,
                "email": "gokgorzyce@gorzyce.pl",
                "__v": 0
            },
        "scannedPlaces": [],
        "activeCoupons": [],
        "avatar": "male3"
        "__v": 0
    }

### `Update user details by user access token`

#### You need to pass user access token as Authorization token.

```
  PATCH /users/details
```

#### Request body

| Parameter  | Type     | Description                       |
| :--------- | :------- | :-------------------------------- |
| `name`     | `string` | **Required**. New user name.      |
| `email`    | `string` | **Required**. New user email.     |
| `regionId` | `string` | **Required**. New user region id. |

#### Response

    {
        "_id": "634c51d99c60289b62cdded9",
        "name": "Bruno",
        "email": "brunodzi07@gmail.com",
        "phone": "123123122",
        "region": {
                "_id": "63485005b9a6f084791d694a",
                "name": "Gorzyce",
                "placeCount": 0,
                "email": "gokgorzyce@gorzyce.pl",
                "__v": 0
            },
        "scannedPlaces": [],
        "activeCoupons": [],
        "avatar": "male3"
        "__v": 0
    }

#### You need to pass user access token as Authorization token.

```
  PATCH /users/avatar
```

#### Request body

| Parameter | Type                                                           | Description                          |
| :-------- | :------------------------------------------------------------- | :----------------------------------- |
| `avatar`  | `string enum (male1, male2, male3, female1, female2, female3)` | **Required**. User avatar to change. |

#### Response

    {
        "_id": "634c51d99c60289b62cdded9",
        "name": "Bruno",
        "email": "brunodzi07@gmail.com",
        "phone": "123123122",
        "region": {
                "_id": "63485005b9a6f084791d694a",
                "name": "Gorzyce",
                "placeCount": 0,
                "email": "gokgorzyce@gorzyce.pl",
                "__v": 0
            },
        "scannedPlaces": [],
        "activeCoupons": [],
        "avatar": "male3"
        "__v": 0
    }

## Regions module

### Region object

| Field          | Type                | Description                                     |
| :------------- | :------------------ | :---------------------------------------------- |
| `name`         | `string`            | Region name.                                    |
| `email`        | `string`            | Region email.                                   |
| `placeCount`   | `number`            | Place count that are in the region.             |
| `password`     | `string`            | Hashed password (not selected by default).      |
| `refreshToken` | `string`            | Hashed refresh token (not selected by default). |
| `_id`          | `ObjectId (string)` | Region id.                                      |

### `Get all regions`

```
  GET /regions
```

#### Response

    [
        {
            "_id": "63485005b9a6f084791d694a",
            "name": "Gorzyce",
            "placeCount": 0,
            "email": "gokgorzyce@gorzyce.pl",
            "__v": 0
        },
        {
            "_id": "6348524de90df2acac0858a7",
            "name": "Wodzisław Śląski",
            "placeCount": 3,
            "email": "testEmail@email.com",
            "__v": 0
        },
        {
            "_id": "63485252e90df2acac0858a9",
            "name": "Rybnik",
            "placeCount": 10,
            "email": "email@email.com",
            "__v": 0
        },
        ...
    ]

### `Get region by id`

```
  GET /regions/:id
```

#### Request params

| Parameter | Type     | Description              |
| :-------- | :------- | :----------------------- |
| `id`      | `string` | **Required**. Region id. |

#### Response

    {
        "_id": "63485005b9a6f084791d694a",
        "name": "Gorzyce",
        "placeCount": 0,
        "email": "gokgorzyce@gorzyce.pl",
        "__v": 0
    },

## Places module

### Place object

| Field         | Type                         | Description                               |
| :------------ | :--------------------------- | :---------------------------------------- |
| `name`        | `string`                     | Place name.                               |
| `description` | `string`                     | Place description.                        |
| `imageUri`    | `string`                     | Place image URI.                          |
| `region`      | `Region`                     | Place region.                             |
| `points`      | `number`                     | Place points that user gets when he scan. |
| `location`    | `{lat: number; lng: number}` | Place location.                           |
| `code`        | `string`                     | Place QR Code.                            |
| `_id`         | `ObjectId (string)`          | Place id.                                 |

### `Get all places by region id`

```
  GET /places/:regionId
```

#### Request params

| Parameter  | Type     | Description              |
| :--------- | :------- | :----------------------- |
| `regionId` | `string` | **Required**. Region id. |

#### Response

    [
        {
            "_id": "6349524429ff8cc58c9f1275",
            "name": "Kapliczka na Wierzbowej",
            "description": "Super kapliczka na wierzbowej, blisko do Dino",
            "imageUri": "https://google.com",
            "region": {
                "_id": "63485005b9a6f084791d694a",
                "name": "Gorzyce",
                "placeCount": 3,
                "email": "gokgorzyce@gorzyce.pl",
                "__v": 0
            },
            "points": 25,
            "location": {
                "lat": 49.96181,
                "lng": 18.396556,
                "_id": "6349524429ff8cc58c9f1276"
            },
            "__v": 0
        },
        ...
    ]

### `Scan place QR Code`

#### You need to pass access token as Authorization token.

```
  POST /places/:qrCode
```

#### Request params

| Parameter | Type     | Description                  |
| :-------- | :------- | :--------------------------- |
| `qrCode`  | `string` | **Required**. Place QR Code. |

#### Response

    {
        "_id": "6349886a3077ee6a27f80390",
        "name": "Bruno Dzięcielski",
        "email": "brunodzi07@gmail.com",
        "phone": "123123123",
        "region":{
            "_id": "63485005b9a6f084791d694a",
            "name": "Gorzyce",
            "placeCount": 3,
            "email": "gokgorzyce@gorzyce.pl",
            "__v": 0
        },
        "scannedPlaces": [
            {
                "_id": "6349524429ff8cc58c9f1275",
                "name": "Kapliczka na Wierzbowej",
                "description": "Super kapliczka na wierzbowej, blisko do Dino",
                "imageUri": "https://google.com",
                "region": {
                    "_id": "63485005b9a6f084791d694a",
                    "name": "Gorzyce",
                    "__v": 0
                },
                "points": 25,
                "location": {
                    "lat": 49.96181,
                    "lng": 18.396556,
                    "_id": "6349524429ff8cc58c9f1276"
                },
                "__v": 0
            },
            ...
        ],
        "__v": 0,
        "points": {
            "63485005b9a6f084791d694a": 9625
        },
        "activeCoupons": []
    }

TODO: Add create place to documentation

## Coupons module

### Coupon object

| Field      | Type                | Description         |
| :--------- | :------------------ | :------------------ |
| `name`     | `string`            | Coupon name.        |
| `imageUri` | `string`            | Coupon image URI.   |
| `points`   | `number`            | Coupon points cost. |
| `region`   | `Region`            | Coupon region.      |
| `_id`      | `ObjectId (string)` | Coupon id.          |

### `Get all coupons by region id`

```
  GET /coupons/:regionId
```

#### Request params

| Parameter  | Type     | Description              |
| :--------- | :------- | :----------------------- |
| `regionId` | `string` | **Required**. Region id. |

#### Response

    [
        {
            "_id": "634be2ceaf1a5d95a953d4a7",
            "name": "30 minut darmowej jazdy w PKS Racibórz",
            "imageUri": "https://google.com",
            "points": 100,
            "region": {
                "_id": "63485005b9a6f084791d694a",
                "name": "Gorzyce",
                "placeCount": 3,
                "email": "gokgorzyce@gorzyce.pl",
                "__v": 0
            }
            "__v": 0
        },
        {
            "_id": "634be3a4af1a5d95a953d4ae",
            "name": "Darmowy wstęp na kąpielisko w Olzie",
            "imageUri": "https://google.com",
            "points": 200,
            "region": {
                "_id": "63485005b9a6f084791d694a",
                "name": "Gorzyce",
                "placeCount": 3,
                "email": "gokgorzyce@gorzyce.pl",
                "__v": 0
            }
            "__v": 0
        },
        ...
    ]

### `Activate coupon`

#### You need to pass access token as Authorization token.

```
  POST /coupons/activate/:couponId
```

#### Request params

| Parameter  | Type     | Description              |
| :--------- | :------- | :----------------------- |
| `couponId` | `string` | **Required**. Coupon id. |

#### Response

    {
        "_id": "6349886a3077ee6a27f80390",
        "name": "Bruno Dzięcielski",
        "email": "brunodzi07@gmail.com",
        "phone": "123123123",
        "region": {
            "_id": "63485005b9a6f084791d694a",
            "name": "Gorzyce",
            "placeCount": 3,
            "email": "gokgorzyce@gorzyce.pl",
            "__v": 0
        }
        "scannedPlaces": [
            ...
        ],
        "__v": 0,
        "points": {
            "63485005b9a6f084791d694a": 9600
        },
        "activeCoupons": [
            {
                "coupon": {
                    "_id": "634be2ceaf1a5d95a953d4a7",
                    "name": "30 minut darmowej jazdy w PKS Racibórz",
                    "imageUri": "https://google.com",
                    "points": 100,
                    "region": {
                        "_id": "63485005b9a6f084791d694a",
                        "name": "Gorzyce",
                        "placeCount": 3,
                        "email": "gokgorzyce@gorzyce.pl",
                        "__v": 0
                    }
                    "__v": 0
                },
                "validUntil": "2022-10-16T19:40:36.403Z",
                "_id": "634c5ab09c60289b62cddf44"
            },
            ...
        ],
        "avatar": "male3"
    }

TODO: Add create coupon to documentation
