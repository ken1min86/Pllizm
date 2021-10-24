import { PostsOfMeAndFollower } from 'util/types/redux/posts';
import { Threads } from 'util/types/redux/threads';

import { Users } from '../../util/types/redux/users';

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
    hasRightToUsePlizm: true,
    performedRefract: true,
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
