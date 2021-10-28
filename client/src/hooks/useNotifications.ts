import { useState } from 'react';
import { useSelector } from 'react-redux';
import { getHasRightToUsePlizm, getUser } from 'reducks/users/selectors';
import { axiosBase } from 'util/api';
import { RequestHeadersForAuthentication } from 'util/types/common';
import { Notofication, ResponseOfNotifications } from 'util/types/hooks/notifications';
import { Users } from 'util/types/redux/users';

const useNotifications = () => {
  const selector = useSelector((state: { users: Users }) => state)
  const hasRightToUsePlizm = getHasRightToUsePlizm(selector)

  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const [notifications, setNotifications] = useState<Array<Notofication>>([])

  const getNotifications = () => {
    setLoading(true)
    setError('')
    const user = getUser(selector)
    const requestHeaders: RequestHeadersForAuthentication = {
      'access-token': user.accessToken,
      client: user.client,
      uid: user.uid,
    }
    axiosBase
      .get<ResponseOfNotifications>('/v1/notifications', { headers: requestHeaders })
      .then((response) => {
        const responseOfNotifications = response.data.notifications
        if (hasRightToUsePlizm) {
          setNotifications(responseOfNotifications)
        } else {
          const extractedNotifications = responseOfNotifications.filter(
            (notificaiton) => notificaiton.action === 'request' || notificaiton.action === 'accept',
          )
          setNotifications(extractedNotifications)
        }
      })
      .catch(() => {
        setError('エラーが発生しました。')
      })
      .finally(() => {
        setLoading(false)
      })
  }

  return { getNotifications, loading, error, notifications }
}

export default useNotifications
