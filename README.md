# Amplify (WebAPI)

[![CircleCI](https://circleci.com/gh/wcoombs/Amplify-Web.svg?style=shield&circle-token=030f03a14524c5530c203dc2c5f8b0d733389c2f)](https://circleci.com/gh/wcoombs/Amplify-Web)

### API Endpoint Reference

##### Registration
|  Method  |  Endpoint  |  Usage  |  Permission  |  Returns  |
| -------- | ---------- | ------- | ------------ |  -------- |
| POST | /api/register/`room_id` | Join a room | Anybody | - |

##### Rooms
|  Method  |  Endpoint  |  Usage  |  Permission  |  Returns  |
| -------- | ---------- | ------- | ------------ |  -------- |
| POST | /api/rooms/ | Create a room | Anybody | - |
| DELETE | /api/rooms/`room_id` | Destroy a room | Anybody | - |

##### Playlists
|  Method  |  Endpoint  |  Usage  |  Permission  |  Returns  |
| -------- | ---------- | ------- | ------------ |  -------- |
| GET | /api/playlist/`room_id` | View playlist | Authenticated | Tracks |
| PUT | /api/playlist/`room_id`/`track_id` | Vote on a track | Authenticated | Track |
