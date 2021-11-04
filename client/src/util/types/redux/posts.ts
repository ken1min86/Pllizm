// ***************************************
// Actions
export type GetPostsOfMeAndFollowerAction = (posts: Array<PostsOfMeAndFollower>) => {
  type: string
  payload: Array<PostsOfMeAndFollower>
}

// ***************************************
// Reducers
export type Reducer = (
  state: Array<PostsOfMeAndFollower>,
  action: {
    type: string
    payload: Array<PostsOfMeAndFollower>
  },
) => Array<PostsOfMeAndFollower>

export type PostsArrayOfMeAndFollowerResponse = {
  posts: Array<PostsOfMeAndFollowerRespose>
}

// ***************************************
// Operatons & Selectors
export interface PostsOfMeAndFollowerRespose {
  id: string
  locked?: boolean
  status: 'exist' | 'deleted' | 'not_exist'
  content?: string
  // eslint-disable-next-line camelcase
  posted_by: 'me' | 'follower'
  // eslint-disable-next-line camelcase
  user_id?: string
  // eslint-disable-next-line camelcase
  user_name?: string
  // eslint-disable-next-line camelcase
  icon_url?: string
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

export type PostsOfMeAndFollower = {
  status: 'exist' | 'deleted' | 'not_exist'
  postedBy: 'me' | 'follower'
  userId?: string
  userName?: string
  iconUrl?: string
  id: string
  content?: string
  imageUrl?: string
  locked?: boolean
  isReply: boolean
  likesCount?: number
  repliesCount: number
  likedByCurrentUser: boolean
  createdAt: string
}

export type SubmitPostOperation = (locked: boolean, content?: string, image?: File) => void

export type SubmitReplyOperation = (repliedPostId: string, locked: boolean, content?: string, image?: File) => void
