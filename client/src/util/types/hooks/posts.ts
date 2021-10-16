export type ExistentPosts = {
  id: string
  locked?: boolean
  status: 'exist'
  content?: string
  // eslint-disable-next-line camelcase
  posted_by: 'me' | 'follower'
  // eslint-disable-next-line camelcase
  user_id?: string
  // eslint-disable-next-line camelcase
  user_name?: string
  // eslint-disable-next-line camelcase
  icon_url: string
  // eslint-disable-next-line camelcase
  image_url?: string
  // eslint-disable-next-line camelcase
  is_reply: boolean
  // eslint-disable-next-line camelcase
  likes_count?: number
  // eslint-disable-next-line camelcase
  replies_count: number
  // eslint-disable-next-line camelcase
  liked_by_current_user: boolean
  // eslint-disable-next-line camelcase
  created_at: string
}

export type ResponstOfExistentPosts = {
  posts: Array<ExistentPosts>
}
