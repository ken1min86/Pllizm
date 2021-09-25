import { SignUpAction } from './types'

export const SIGN_UP = 'SIGN_UP'
export const signUpAction: SignUpAction = (userState) => ({
  type: 'SIGN_UP',
  payload: {
    isSignedIn: true,
    uid: userState.uid,
    accessToken: userState.accessToken,
    client: userState.client,
    userId: userState.userId,
    userName: userState.userName,
  },
})
