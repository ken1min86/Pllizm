import { Users } from '../users/types';

const initialState: { users: Users } = {
  users: {
    isSignedIn: false,
    uid: '',
    accessToken: '',
    client: '',
    userId: '',
    userName: '',
  },
}

export default initialState
