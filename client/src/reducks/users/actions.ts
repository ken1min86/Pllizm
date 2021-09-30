import { SignInAction, SignUpAction } from './types';

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
    icon: userState.icon,
  },
})

export const SIGN_IN = 'SIGN_IN'
export const signInAction: SignInAction = (userState) => ({
  type: 'SIGN_IN',
  payload: {
    isSignedIn: true,
    uid: userState.uid,
    accessToken: userState.accessToken,
    client: userState.client,
    userId: userState.userId,
    userName: userState.userName,
    icon: userState.icon,
  },
})
