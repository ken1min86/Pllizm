import { RequestHeadersForAuthentication } from 'util/types/redux/users';

export type User = {
  // eslint-disable-next-line camelcase
  user_id: string
  // eslint-disable-next-line camelcase
  user_name: string
  // eslint-disable-next-line camelcase
  image_url: string
  bio: string
}

export type UserProfile = {
  // eslint-disable-next-line camelcase
  is_current_user: boolean
  // eslint-disable-next-line camelcase
  icon_url?: string
  // eslint-disable-next-line camelcase
  user_name: string
  // eslint-disable-next-line camelcase
  user_id: string
  bio?: string
  // eslint-disable-next-line camelcase
  followers_count?: number
  // eslint-disable-next-line camelcase
  follow_requests_to_me_count?: number
  // eslint-disable-next-line camelcase
  follow_requests_by_me_count?: number
  following: boolean
  // eslint-disable-next-line camelcase
  follow_request_sent_to_me: boolean
  // eslint-disable-next-line camelcase
  follow_requet_sent_by_me: boolean
}

export type ReponseOfUsers = {
  users: Array<User>
}

export type RequestHeaders = RequestHeadersForAuthentication
