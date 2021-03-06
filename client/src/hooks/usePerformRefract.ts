import { useState } from 'react';
import { useSelector } from 'react-redux';
import { getUser } from 'reducks/users/selectors';
import { axiosBase } from 'util/api';
import { ErrorStatus, RequestHeadersForAuthentication } from 'util/types/common';
import { Users } from 'util/types/redux/users';

const usePerformRefract = () => {
  const selector = useSelector((state: { users: Users }) => state)

  const [errorMessage, setErrorMessage] = useState('')

  const performRefract = (refractCandidateId: string) => {
    const loginUser = getUser(selector)
    const requestHeaders: RequestHeadersForAuthentication = {
      'access-token': loginUser.accessToken,
      client: loginUser.client,
      uid: loginUser.uid,
    }
    axiosBase
      .post('v1/refracts/perform', { refract_candidate_id: refractCandidateId }, { headers: requestHeaders })
      .then(() => {
        window.location.href = '/refracted_posts'
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
  }

  return { performRefract, errorMessage }
}

export default usePerformRefract
