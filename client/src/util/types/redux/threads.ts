import { Weaken } from 'util/types/common';

import { PostsOfMeAndFollower } from './posts';

// ***************************************
// Actions
export type GetThreadAction = (thread: Threads) => {
  type: string
  payload: Threads
}

// ***************************************
// Reducers
export type Reducer = (
  state: Threads,
  action: {
    type: string
    payload: Threads
  },
) => Threads

// ***************************************
// Operatons & Selectors
export type Threads = {
  parent: PostInThread
  current: PostInThread
  children: Array<PostInThread>
}

export interface PostInThread extends Weaken<PostsOfMeAndFollower, 'postedBy'> {
  postedBy: 'me' | 'follower' | 'not_follower' | undefined
  status: 'exist' | 'deleted' | 'not_exist'
}
