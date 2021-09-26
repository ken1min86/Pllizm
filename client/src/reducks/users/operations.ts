/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/explicit-module-boundary-types */
import { push } from 'connected-react-router';
import { isValidEmailFormat } from 'function/common';
import Cookies from 'js-cookie';
import { setErrors } from 'reducks/errors/operations';

import axiosBase from '../../api';
import { signInAction, signUpAction } from './actions';
import {
    ListenAuthStateRequest, RequestHeadersForAuthentication, SignInRequest, SignUpRequest,
    SignUpResponse
} from './types';

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export const signUp = (email: string, password: string, passwordConfirmation: string) => async (dispatch: any) => {
  if (email === '' || password === '' || passwordConfirmation === '') {
    // eslint-disable-next-line @typescript-eslint/no-unsafe-call
    dispatch(setErrors(['必須項目が未入力です']))

    return false
  }

  if (!isValidEmailFormat(email)) {
    // eslint-disable-next-line @typescript-eslint/no-unsafe-call
    dispatch(setErrors(['メールアドレスの形式が不正です。']))

    return false
  }

  if (password.length < 8) {
    // eslint-disable-next-line @typescript-eslint/no-unsafe-call
    dispatch(setErrors(['パスワードは8文字以上で設定してください。']))

    return false
  }

  if (password !== passwordConfirmation) {
    // eslint-disable-next-line @typescript-eslint/no-unsafe-call
    dispatch(setErrors(['パスワードが一致しません。']))

    return false
  }

  const requestData: SignUpRequest = { email, password, password_confirmation: passwordConfirmation }

  await axiosBase
    .post<SignUpResponse>('/v1/auth', requestData)
    .then((response) => {
      const { headers } = response
      const accessToken: string = headers['access-token']
      const { client, uid } = headers
      Cookies.set('access-token', accessToken)
      Cookies.set('client', client)
      Cookies.set('uid', uid)

      const userData = response.data.data
      // eslint-disable-next-line @typescript-eslint/no-unsafe-call
      dispatch(
        signUpAction({
          uid,
          accessToken,
          client,
          userId: userData.userid,
          userName: userData.username,
        }),
      )
      // eslint-disable-next-line @typescript-eslint/no-unsafe-call
      dispatch(push('/home'))
    })
    .catch((error) => {
      const errorsMessages: Array<string> = error.response.data.errors.full_messages
      if (errorsMessages.some((message) => message === 'Email has already been taken')) {
        // eslint-disable-next-line @typescript-eslint/no-unsafe-call
        dispatch(setErrors(['すでに登録済みのメールアドレスです。\n別のメールアドレスで登録してください。']))

        return false
      }
      // eslint-disable-next-line @typescript-eslint/no-unsafe-call
      dispatch(setErrors(['不正なリクエストです。']))

      return false
    })

  return false
}

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export const signIn = (email: string, password: string) => async (dispatch: any, getState: any) => {
  if (email === '' || password === '') {
    // eslint-disable-next-line @typescript-eslint/no-unsafe-call
    dispatch(setErrors(['メールアドレスとパスワードを入力してください。']))

    return false
  }

  if (!isValidEmailFormat(email)) {
    // eslint-disable-next-line @typescript-eslint/no-unsafe-call
    dispatch(setErrors(['メールアドレスの形式が不正です。']))

    return false
  }

  const requestData: SignInRequest = { email, password }
  // eslint-disable-next-line @typescript-eslint/no-unsafe-call
  const { uid, accessToken, client } = getState().users
  const requestHeaders: RequestHeadersForAuthentication = {
    'access-token': accessToken,
    client,
    uid,
  }

  await axiosBase
    .post('/v1/auth/sign_in', requestData, { headers: requestHeaders })
    .then((response) => {
      const { headers } = response
      Cookies.set('access-token', headers['access-token'])
      Cookies.set('client', headers.client)
      Cookies.set('uid', headers.uid)

      const userData = response.data.data
      // eslint-disable-next-line @typescript-eslint/no-unsafe-call
      dispatch(
        signInAction({
          uid,
          accessToken,
          client,
          userId: userData.userid,
          userName: userData.username,
        }),
      )
      // eslint-disable-next-line @typescript-eslint/no-unsafe-call
      dispatch(push('/home'))
    })
    .catch(() => {
      // eslint-disable-next-line @typescript-eslint/no-unsafe-call
      dispatch(setErrors(['オフラインか、メールアドレスまたはパスワードが間違っています。']))

      return false
    })

  return false
}

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export const listenAuthState = () => async (dispatch: any) => {
  const accessTokenInCookie = Cookies.get('access-token')
  const clientInCookie = Cookies.get('client')
  const uidInCookie = Cookies.get('uid')

  const requestData: ListenAuthStateRequest = {
    'access-token': accessTokenInCookie,
    client: clientInCookie,
    uid: uidInCookie,
  }

  await axiosBase
    .get('/v1/auth/validate_token', { params: requestData })
    .then((response) => {
      const { headers } = response
      const accessToken: string = headers['access-token']
      const { client, uid } = headers

      Cookies.set('access-token', accessToken)
      Cookies.set('client', client)
      Cookies.set('uid', uid)

      const userData = response.data.data
      const { userId, userName } = userData
      // eslint-disable-next-line @typescript-eslint/no-unsafe-call
      dispatch(
        signUpAction({
          uid,
          accessToken,
          client,
          userId,
          userName,
        }),
      )
      // eslint-disable-next-line @typescript-eslint/no-unsafe-call
      dispatch(push('/home'))
    })
    .catch(() => {
      // eslint-disable-next-line @typescript-eslint/no-unsafe-call
      dispatch(push('/'))
    })
}