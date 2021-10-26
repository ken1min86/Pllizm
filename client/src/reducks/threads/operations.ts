import camelcaseKeys from 'camelcase-keys';
import { axiosBase } from 'util/api';
import { createRequestHeader } from 'util/functions/common';
import { UsersOfGetState } from 'util/types/redux/users';

import { Threads } from '../../util/types/redux/threads';
import { getThreadAction } from './actions';

export const getThread =
  (postId: string) =>
  async (dispatch: (arg0: { type: string; payload: Threads }) => void, getState: UsersOfGetState): Promise<void> => {
    const requestHeaders = createRequestHeader(getState)

    await axiosBase
      .get<Threads>(`/v1/posts/${postId}/threads`, { headers: requestHeaders })
      .then((response) => {
        const { parent, current, children } = response.data
        const formattedParent = camelcaseKeys(parent)
        const formattedCurrent = camelcaseKeys(current)
        const formattedChildren = children.map((child) => camelcaseKeys(child))
        const thread = { parent: formattedParent, current: formattedCurrent, children: formattedChildren }
        dispatch(getThreadAction(thread))
      })
      .catch((errors) => {
        console.log(errors)
      })
  }
