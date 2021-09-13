import { Errors } from '../errors/types'
import { Users } from '../users/types'

const initialState: { users: Users; errors: Errors } = {
  users: {
    isSignedIn: false,
    uid: '',
    accessToken: '',
    client: '',
    userId: '',
    userName: '',
  },
  errors: {
    list: [],
  },
}

export default initialState
