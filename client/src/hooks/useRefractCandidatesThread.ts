import { useState } from 'react';
import { useSelector } from 'react-redux';
import { getUser } from 'reducks/users/selectors';
import { axiosBase } from 'util/api';
import { ErrorStatus, RequestHeadersForAuthentication } from 'util/types/common';
import {
    RefractCandidateInThread, ResponseOfRefractCandidatesInThread
} from 'util/types/hooks/posts';
import { Users } from 'util/types/redux/users';

const useRefractCandidatesThread = (postId: string) => {
  const selector = useSelector((state: { users: Users }) => state)

  const [posts, setPosts] = useState<Array<RefractCandidateInThread>>([])
  const [loading, setLoading] = useState(false)
  const [errorMessage, setErrorMessage] = useState('')

  const getRefractCandidatesThread = () => {
    setPosts([])
    setLoading(true)
    setErrorMessage('')

    const loginUser = getUser(selector)
    const requestHeaders: RequestHeadersForAuthentication = {
      'access-token': loginUser.accessToken,
      client: loginUser.client,
      uid: loginUser.uid,
    }

    axiosBase
      .get<ResponseOfRefractCandidatesInThread>(`v1/refract_candidates/${postId}/threads`, {
        headers: requestHeaders,
      })
      .then((response) => {
        setPosts(response.data.posts)
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
  }

  return { getRefractCandidatesThread, posts, loading, errorMessage }
}

export default useRefractCandidatesThread
