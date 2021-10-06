import camelcaseKeys from 'camelcase-keys';
import { RequestHeadersForAuthentication, UsersOfGetState } from 'reducks/users/types';

import axiosBase from '../../api';
import DefaultIcon from '../../assets/DefaultIcon.jpg';
import { getPostsOfMeAndFollowerAction } from './actions';
import { PostsArrayOfMeAndFollowerResponse, PostsOfMeAndFollower } from './types';

// eslint-disable-next-line import/prefer-default-export
export const getPostsOfMeAndFollower = () => async (dispatch: any, getState: UsersOfGetState) => {
  const { uid, accessToken, client } = getState().users
  const requestHeaders: RequestHeadersForAuthentication = {
    'access-token': accessToken,
    client,
    uid,
  }

  await axiosBase
    .get<PostsArrayOfMeAndFollowerResponse>('/v1/posts/me_and_followers', { headers: requestHeaders })
    .then((response) => {
      const { posts } = response.data
      const postsWithCamelcaseKeys = posts.map((post) => camelcaseKeys(post))
      const postsWithIcon: Array<PostsOfMeAndFollower> = postsWithCamelcaseKeys.map((post) => {
        const iconUrl = post.iconUrl == null ? DefaultIcon : post.iconUrl
        const postWithIcon = { ...post, iconUrl }

        return postWithIcon
      })

      // eslint-disable-next-line @typescript-eslint/no-unsafe-call
      dispatch(getPostsOfMeAndFollowerAction(postsWithIcon))
    })
}
