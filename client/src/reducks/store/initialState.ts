import { Posts } from 'reducks/posts/types';

import { Users } from '../users/types';

const initialState: { users: Users; posts: Array<Posts> } = {
  users: {
    isSignedIn: false,
    uid: '',
    accessToken: '',
    client: '',
    userId: '',
    userName: '',
    icon: '',
  },
  posts: [],
}

export default initialState
