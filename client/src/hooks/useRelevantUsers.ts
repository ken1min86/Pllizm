import { useState } from 'react';
import { useSelector } from 'react-redux';
import { getUser } from 'reducks/users/selectors';
import { axiosBase } from 'util/api';
import { ErrorStatus, RequestHeadersForAuthentication } from 'util/types/common';
import { RelevantUser, ResponseRelevantUsers } from 'util/types/hooks/users';
import { Users } from 'util/types/redux/users';

const useRelevantUsers = (
  who: 'followers' | 'usersRequestFollowingToMe' | 'usersRequestedFollowingByMe',
  tabValue: 'followers' | 'usersRequestFollowingToMe' | 'usersRequestedFollowingByMe',
) => {
  const selector = useSelector((state: { users: Users }) => state)

  const [loading, setLoading] = useState(false)
  const [errorMessage, setErrorMessage] = useState('')
  const [relevantUsers, setRelevantUsers] = useState<Array<RelevantUser>>()

  const getInitialRelationship = (
    withWho: 'followers' | 'usersRequestFollowingToMe' | 'usersRequestedFollowingByMe',
  ) => {
    let initialRelationship: 'following' | 'requestedToMe' | 'requestingByMe'
    // eslint-disable-next-line default-case
    switch (withWho) {
      case 'followers':
        initialRelationship = 'following'
        break
      case 'usersRequestFollowingToMe':
        initialRelationship = 'requestedToMe'
        break
      case 'usersRequestedFollowingByMe':
        initialRelationship = 'requestingByMe'
        break
    }

    return initialRelationship
  }
  const [relationship, setRelationship] = useState<'following' | 'requestedToMe' | 'requestingByMe'>(
    getInitialRelationship(who),
  )

  const getRelevantUsers = () => {
    setLoading(true)
    setErrorMessage('')
    setRelevantUsers(undefined)

    const loginUser = getUser(selector)
    const requestHeaders: RequestHeadersForAuthentication = {
      'access-token': loginUser.accessToken,
      client: loginUser.client,
      uid: loginUser.uid,
    }

    switch (tabValue) {
      case 'followers':
        void axiosBase
          .get<ResponseRelevantUsers>('v1/followers', { headers: requestHeaders })
          .then((response) => {
            setRelationship('following')
            setRelevantUsers(response.data.users)
          })
          .catch((error: ErrorStatus) => {
            const { status } = error.response
            if (String(status).indexOf('5') === 0) {
              setErrorMessage('接続が失われました。確認してからやりなおしてください。')
            } else {
              setErrorMessage(
                '予期せぬエラーが発生しました。オフラインでないか確認し、それでもエラーが発生する場合はお問い合わせフォームにて問い合わせ下さい。',
              )
            }
          })
          .finally(() => {
            setLoading(false)
          })
        break

      case 'usersRequestFollowingToMe':
        void axiosBase
          .get<ResponseRelevantUsers>('v1/follow_requests/incoming', { headers: requestHeaders })
          .then((response) => {
            setRelationship('requestedToMe')
            setRelevantUsers(response.data.users)
          })
          .catch((error: ErrorStatus) => {
            const { status } = error.response
            if (String(status).indexOf('5') === 0) {
              setErrorMessage('接続が失われました。確認してからやりなおしてください。')
            } else {
              setErrorMessage(
                '予期せぬエラーが発生しました。オフラインでないか確認し、それでもエラーが発生する場合はお問い合わせフォームにて問い合わせ下さい。',
              )
            }
          })
          .finally(() => {
            setLoading(false)
          })
        break

      case 'usersRequestedFollowingByMe':
        void axiosBase
          .get<ResponseRelevantUsers>('v1/follow_requests/outgoing', { headers: requestHeaders })
          .then((response) => {
            setRelationship('requestingByMe')
            setRelevantUsers(response.data.users)
          })
          .catch((error: ErrorStatus) => {
            const { status } = error.response
            if (String(status).indexOf('5') === 0) {
              setErrorMessage('接続が失われました。確認してからやりなおしてください。')
            } else {
              setErrorMessage(
                '予期せぬエラーが発生しました。オフラインでないか確認し、それでもエラーが発生する場合はお問い合わせフォームにて問い合わせ下さい。',
              )
            }
          })
          .finally(() => {
            setLoading(false)
          })
        break

      default:
        setErrorMessage(
          '予期せぬエラーが発生しました。オフラインでないか確認し、それでもエラーが発生する場合はお問い合わせフォームにて問い合わせ下さい。',
        )
        setLoading(false)
        break
    }
  }

  return { getRelevantUsers, loading, errorMessage, relevantUsers, relationship }
}

export default useRelevantUsers
