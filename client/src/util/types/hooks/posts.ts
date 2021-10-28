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

export type RefractCandidate = ExistentPosts & {
  category: 'reply' | 'like'
}

export type RefractCandidateInThread = ExistentPosts & {
  status: 'exist' | 'deleted' | 'not_exist'
  // eslint-disable-next-line camelcase
  posted_by?: 'me' | 'follower' | 'not_follower'
}

export type PostRefractedByMe = RefractCandidateInThread

export type PostRefractedByFollower = RefractCandidateInThread

export type RefractPerformedByMe = {
  // eslint-disable-next-line camelcase
  refracted_at: string
  posts: Array<PostRefractedByMe>
}

export type RefractPerformedByFollower = {
  // eslint-disable-next-line camelcase
  refracted_at: string
  posts: Array<PostRefractedByFollower>
  // eslint-disable-next-line camelcase
  refracted_by: {
    // eslint-disable-next-line camelcase
    user_id: string
    // eslint-disable-next-line camelcase
    user_name: string
  }
}

// ***************************************
// Responses
export type ResponseOfExistentPosts = {
  posts: Array<ExistentPosts>
}

export type ResponseOfRefractCandidates = {
  posts: Array<RefractCandidate>
}

export type ResponseOfRefractCandidatesInThread = {
  posts: Array<RefractCandidateInThread>
}

export type ResponseOfRefractsPerformedByMe = {
  refracts: Array<RefractPerformedByMe>
}

export type ResponseOfRefractsPerformedByFollower = {
  refracts: Array<RefractPerformedByFollower>
}
