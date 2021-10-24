import { useState } from 'react';
import { useSelector } from 'react-redux';
import { getUser } from 'reducks/users/selectors';
import { axiosBase } from 'util/api';
import { formatPostsOfRefractCandidate } from 'util/functions/common';
import { ErrorStatus } from 'util/types/common';
import { RefractCandidate, ResponstOfRefractCandidates } from 'util/types/hooks/posts';
import { RequestHeaders } from 'util/types/hooks/users';
import { Users } from 'util/types/redux/users';

const useRefractCandidates = () => {
  const selector = useSelector((state: { users: Users }) => state)

  const [posts, setPosts] = useState<Array<RefractCandidate>>([])
  const [loading, setLoading] = useState(false)
  const [errorMessage, setErrorMessage] = useState('')

  const getRefractCandidates = () => {
    setPosts([])
    setLoading(true)
    setErrorMessage('')

    const loginUser = getUser(selector)
    const requestHeaders: RequestHeaders = {
      'access-token': loginUser.accessToken,
      client: loginUser.client,
      uid: loginUser.uid,
    }

    axiosBase
      .get<ResponstOfRefractCandidates>('v1/refract_candidates', { headers: requestHeaders })
      .then((response) => {
        const postsData = response.data.posts
        const formattedPostsData = formatPostsOfRefractCandidate(postsData)
        setPosts(formattedPostsData)
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

  return { getRefractCandidates, posts, loading, errorMessage }
}

export default useRefractCandidates
