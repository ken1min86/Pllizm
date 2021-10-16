import { GetPostsOfMeAndFollowerAction } from '../../util/types/redux/posts';

export const GET_POSTS_OF_ME_AND_FOLLOWER = 'GET_POSTS_OF_ME_AND_FOLLOWER'
export const getPostsOfMeAndFollowerAction: GetPostsOfMeAndFollowerAction = (posts) => ({
  type: 'GET_POSTS_OF_ME_AND_FOLLOWER',
  payload: posts,
})
