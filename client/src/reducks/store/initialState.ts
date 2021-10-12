import { PostsOfMeAndFollower } from 'reducks/posts/types';
import { Threads } from 'reducks/threads/types';

import { Users } from '../users/types';

const initialState: { users: Users; posts: Array<PostsOfMeAndFollower>; threads: Threads } = {
  users: {
    isSignedIn: false,
    uid: '',
    accessToken: '',
    client: '',
    userId: '',
    userName: '',
    icon: '',
    needDescriptionAboutLock: true,
  },
  posts: [],
  threads: {
    parent: {
      status: 'not_exist',
      postedBy: undefined,
      userId: undefined,
      userName: undefined,
      iconUrl: '',
      id: '',
      content: '',
      imageUrl: '',
      locked: undefined,
      isReply: false,
      likesCount: 0,
      repliesCount: 0,
      likedByCurrentUser: false,
      createdAt: '',
    },
    current: {
      status: 'not_exist',
      postedBy: undefined,
      userId: undefined,
      userName: undefined,
      iconUrl: '',
      id: '',
      content: '',
      imageUrl: '',
      locked: undefined,
      isReply: false,
      likesCount: 0,
      repliesCount: 0,
      likedByCurrentUser: false,
      createdAt: '',
    },
    children: [],
  },
}

export default initialState
