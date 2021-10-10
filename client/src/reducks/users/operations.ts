/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
import { push } from 'connected-react-router';
import { createRequestHeader, isValidEmailFormat } from 'function/common';
import Cookies from 'js-cookie';

import { axiosBase } from '../../api';
import DefaultIcon from '../../assets/DefaultIcon.jpg';
import { signInAction, signOutAction, signUpAction } from './actions';
import {
    ListenAuthStateRequest, SignInRequest, SignUpRequest, SignUpResponse, UsersOfGetState
} from './types';

export const signUp =
  (
    email: string,
    password: string,
    passwordConfirmation: string,
    setError: React.Dispatch<React.SetStateAction<string>>,
  ) =>
  async (dispatch: any): Promise<boolean> => {
    if (email === '' || password === '' || passwordConfirmation === '') {
      setError('必須項目が未入力です。')

      return false
    }

    if (!isValidEmailFormat(email)) {
      setError('メールアドレスの形式が不正です。')

      return false
    }

    if (password.length < 8) {
      setError('パスワードは8文字以上で設定してください。')

      return false
    }

    if (password !== passwordConfirmation) {
      setError('パスワードが一致しません。')

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
        const icon = userData.image.url == null ? DefaultIcon : userData.image.url
        // eslint-disable-next-line @typescript-eslint/no-unsafe-call
        dispatch(
          signUpAction({
            uid,
            accessToken,
            client,
            userId: userData.userid,
            userName: userData.username,
            icon,
            needDescriptionAboutLock: userData.need_description_about_lock,
          }),
        )
        // eslint-disable-next-line @typescript-eslint/no-unsafe-call
        dispatch(push('/home'))
      })
      .catch((error) => {
        const errorsMessages: Array<string> = error?.response?.data?.errors?.full_messages
        if (errorsMessages?.some((message) => message === 'Email has already been taken')) {
          setError('すでに登録済みのメールアドレスです。\n別のメールアドレスで登録してください。')

          return false
        }
        if (errorsMessages?.some((message) => message === 'Email is not an email')) {
          setError('不正なメールアドレスです。\nメールアドレスに間違えがないか確認して下さい。')

          return false
        }
        setError('不正なリクエストです。')

        return false
      })

    return false
  }

export const signIn =
  (email: string, password: string, setError: React.Dispatch<React.SetStateAction<string>>) =>
  async (dispatch: any): Promise<boolean> => {
    if (email === '' || password === '') {
      setError('メールアドレスとパスワードを入力してください。')

      return false
    }

    if (!isValidEmailFormat(email)) {
      setError('メールアドレスの形式が不正です。')

      return false
    }

    const requestData: SignInRequest = { email, password }

    await axiosBase
      .post('/v1/auth/sign_in', requestData)
      .then((response) => {
        const { headers } = response
        const accessToken = headers['access-token']
        const { client, uid } = headers

        Cookies.set('access-token', accessToken)
        Cookies.set('client', client)
        Cookies.set('uid', uid)

        const userData = response.data.data
        const icon = userData.image.url == null ? DefaultIcon : userData.image.url
        // eslint-disable-next-line @typescript-eslint/no-unsafe-call
        dispatch(
          signInAction({
            uid,
            accessToken,
            client,
            userId: userData.userid,
            userName: userData.username,
            icon,
            needDescriptionAboutLock: userData.need_description_about_lock,
          }),
        )
        // eslint-disable-next-line @typescript-eslint/no-unsafe-call
        dispatch(push('/home'))
      })
      .catch(() => {
        setError('オフラインか、メールアドレスまたはパスワードが間違っています。')

        return false
      })

    return false
  }

export const signOut =
  (setError: React.Dispatch<React.SetStateAction<string>>) =>
  async (dispatch: any, getState: UsersOfGetState): Promise<any> => {
    const requestHeaders = createRequestHeader(getState)

    await axiosBase
      .delete('v1/auth/sign_out', { headers: requestHeaders })
      .then(() => {
        Cookies.remove('access-token')
        Cookies.remove('client')
        Cookies.remove('uid')

        // eslint-disable-next-line @typescript-eslint/no-unsafe-call
        dispatch(signOutAction())
        // eslint-disable-next-line @typescript-eslint/no-unsafe-call
        dispatch(push('/'))
      })
      .catch(() => {
        setError('オフラインでないことを確認して、もう一度ログアウトして下さい。')
      })
  }

export const listenAuthState =
  () =>
  async (dispatch: any): Promise<any> => {
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
        const { userid, username } = userData
        const icon = userData.image.url == null ? DefaultIcon : userData.image.url
        // eslint-disable-next-line @typescript-eslint/no-unsafe-call
        dispatch(
          signInAction({
            uid,
            accessToken,
            client,
            userId: userid,
            userName: username,
            icon,
            needDescriptionAboutLock: userData.need_description_about_lock,
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

export const sendMailOfPasswordReset =
  (email: string, setError: React.Dispatch<React.SetStateAction<string>>) =>
  async (dispatch: any): Promise<any> => {
    if (email === '') {
      setError('メールアドレスが未入力です。')

      return false
    }

    if (!isValidEmailFormat(email)) {
      setError('メールアドレスの形式が不正です。')

      return false
    }

    let redirectUrl
    switch (process.env.NODE_ENV) {
      case 'production':
        // eslint-disable-next-line @typescript-eslint/restrict-template-expressions
        redirectUrl = `${process.env.REACT_APP_PROD_CLIENT_URL}/users/password_reset`
        break

      case 'development':
      case 'test':
        // eslint-disable-next-line @typescript-eslint/restrict-template-expressions
        redirectUrl = `${process.env.REACT_APP_DEV_CLIENT_URL}/users/password_reset`
        break

      default:
        break
    }

    await axiosBase
      .post('/v1/auth/password', { email, redirect_url: redirectUrl })
      .then(() => {
        // eslint-disable-next-line @typescript-eslint/no-unsafe-call
        dispatch(push('/users/sent_mail_of_password_reset'))
      })
      .catch(() => {
        // eslint-disable-next-line @typescript-eslint/no-unsafe-call
        dispatch(push('/users/sent_mail_of_password_reset'))
      })

    return false
  }

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export const resetPassword =
  (
    password: string,
    passwordConfirmation: string,
    accessToken: string | null,
    client: string | null,
    uid: string | null,
    setError: React.Dispatch<React.SetStateAction<string>>,
  ) =>
  async (dispatch: any): Promise<boolean> => {
    if (password === '' || passwordConfirmation === '') {
      setError('必須項目が未入力です。')

      return false
    }

    if (password.length < 8) {
      setError('パスワードは8文字以上で設定してください。')

      return false
    }

    if (password !== passwordConfirmation) {
      setError('パスワードが一致しません。')

      return false
    }

    const requestHeaders = {
      'access-token': accessToken,
      client,
      uid,
    }

    await axiosBase
      .put('/v1/auth/password', { password, password_confirmation: passwordConfirmation }, { headers: requestHeaders })
      .then((response) => {
        const { headers } = response
        const accessTokenInHeader = headers['access-token']
        const clientInHeader = headers.client
        const uidInHeader = headers.uid

        Cookies.set('access-token', accessTokenInHeader)
        Cookies.set('client', clientInHeader)
        Cookies.set('uid', uidInHeader)

        const userData = response.data.data
        const icon = userData.image.url == null ? DefaultIcon : userData.image.url
        // eslint-disable-next-line @typescript-eslint/no-unsafe-call
        dispatch(
          signInAction({
            uid: uidInHeader,
            accessToken: accessTokenInHeader,
            client: clientInHeader,
            userId: userData.userid,
            userName: userData.username,
            icon,
            needDescriptionAboutLock: userData.need_description_about_lock,
          }),
        )
        // eslint-disable-next-line @typescript-eslint/no-unsafe-call
        dispatch(push('/users/end_password_reset'))
      })
      .catch(() => {
        setError(
          '予期せぬエラーが発生しました。オフラインでないか確認し、それでもエラーが発生する場合はお問い合わせフォームにて問い合わせ下さい。',
        )

        return false
      })

    return false
  }
