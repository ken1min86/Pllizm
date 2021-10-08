import camelcaseKeys from 'camelcase-keys';
import { createRequestHeader } from 'function/common';
import { UsersOfGetState } from 'reducks/users/types';

import { axiosBase } from '../../api';
import DefaultIcon from '../../assets/DefaultIcon.jpg';
import { getPostsOfMeAndFollowerAction } from './actions';
import {
    PostsArrayOfMeAndFollowerResponse, PostsOfMeAndFollower, SubmitPostOperation
} from './types';

export const getPostsOfMeAndFollower =
  () =>
  async (
    dispatch: (arg0: { type: string; payload: PostsOfMeAndFollower[] }) => void,
    getState: UsersOfGetState,
  ): Promise<any> => {
    const requestHeaders = createRequestHeader(getState)

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

        dispatch(getPostsOfMeAndFollowerAction(postsWithIcon))
      })
  }

export const submitNewPost: SubmitPostOperation =
  (content, locked, image) => async (_: any, getState: UsersOfGetState) => {
    const requestHeaders = createRequestHeader(getState)

    const requestData = new FormData()
    requestData.append('content', content)
    requestData.append('is_locked', locked.toString())
    if (image) {
      requestData.append('image', image)
    }

    await axiosBase
      .post('/v1/posts', requestData, { headers: requestHeaders })
      .then(() => {
        window.location.href = '/home'
      })
      .catch((errors) => {
        console.log(errors)
      })
  }
