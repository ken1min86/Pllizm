import { axiosBase } from 'api';
import { UsersOfGetState } from 'reducks/users/types';
import { createRequestHeader, formatPostInThread, formatPostsInThread } from 'Util/common';

import { getThreadAction } from './actions';
import { Threads } from './types';

export const getThread =
  (postId: string) =>
  async (dispatch: (arg0: { type: string; payload: Threads }) => void, getState: UsersOfGetState): Promise<void> => {
    const requestHeaders = createRequestHeader(getState)

    await axiosBase
      .get<Threads>(`/v1/posts/${postId}/threads`, { headers: requestHeaders })
      .then((response) => {
        const { parent, current, children } = response.data
        const formattedParent = formatPostInThread(parent)
        const formattedCurrent = formatPostInThread(current)
        const formattedChildren = formatPostsInThread(children)
        const thread = { parent: formattedParent, current: formattedCurrent, children: formattedChildren }
        dispatch(getThreadAction(thread))
      })
      .catch((errors) => {
        console.log(errors)
      })
  }
