# Amplify (WebAPI)

[![CircleCI](https://circleci.com/gh/wcoombs/Amplify-Web.svg?style=shield&circle-token=030f03a14524c5530c203dc2c5f8b0d733389c2f)](https://circleci.com/gh/wcoombs/Amplify-Web)

# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

### API Endpoint Reference

##### Registration
|  Method  |  Endpoint  |  Usage  |  Permission  |  Returns  |
| -------- | ---------- | ------- | ------------ |  -------- |
| POST | /api/register | Register as Host | Anybody | `auth_token` |
| POST | /api/register/`room_id` | Join a room | Anybody | `auth_token` |

##### Rooms
|  Method  |  Endpoint  |  Usage  |  Permission  |  Returns  |
| -------- | ---------- | ------- | ------------ |  -------- |
| POST | /api/rooms/ | Create a room | Host | Room |
| DELETE | /api/rooms/`room_id` | Destroy a room | Host | - |

##### Playlists
|  Method  |  Endpoint  |  Usage  |  Permission  |  Returns  |
| -------- | ---------- | ------- | ------------ |  -------- |
| GET | /api/playlist/`room_id` | View playlist | Authenticated | Tracks |
| POST | /api/playlist/`room_id`/`track_id` | Add a track | Host | Track |
| PUT | /api/playlist/`room_id`/`track_id` | Vote on a track | Authenticated | Track |
| DELETE | /api/playlist/`room_id`/`track_id` | Remove a track | Host | - |
