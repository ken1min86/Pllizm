import { useState } from 'react';
import { useSelector } from 'react-redux';
import { getUser } from 'reducks/users/selectors';
import { axiosBase } from 'util/api';
import { formatPostsOfMeAndFollower } from 'util/functions/common';
import { ErrorStatus } from 'util/types/common';
import { ExistentPosts, ResponstOfExistentPosts } from 'util/types/hooks/posts';
import { RequestHeaders } from 'util/types/hooks/users';
import { Users } from 'util/types/redux/users';

const usePostsInProfile = (tabValue: '投稿' | 'リプライ' | 'ロック' | 'いいね') => {
  const selector = useSelector((state: { users: Users }) => state)

  const [posts, setPosts] = useState<Array<ExistentPosts>>([])
  const [loading, setLoading] = useState(false)
  const [errorMessageInPosts, setErrorMessageInPosts] = useState('')

  const getPostsInProfile = () => {
    setPosts([])
    setLoading(true)
    const loginUser = getUser(selector)
    const requestHeaders: RequestHeaders = {
      'access-token': loginUser.accessToken,
      client: loginUser.client,
      uid: loginUser.uid,
    }

    switch (tabValue) {
      case '投稿':
        axiosBase
          .get<ResponstOfExistentPosts>('v1/posts/me', { headers: requestHeaders })
          .then((response) => {
            const postsData = response.data.posts
            const formattedPostsData = formatPostsOfMeAndFollower(postsData)
            setPosts(formattedPostsData)
          })
          .catch((error: ErrorStatus) => {
            const { status } = error.response
            if (String(status).indexOf('5') === 0) {
              setErrorMessageInPosts('接続が失われました。確認してからやりなおしてください。')
            } else {
              setErrorMessageInPosts(
                '予期せぬエラーが発生しました。オフラインでないか確認し、それでもエラーが発生する場合はお問い合わせフォームにて問い合わせ下さい。',
              )
            }
          })
          .finally(() => {
            setLoading(false)
          })

        break
      case 'リプライ':
        axiosBase
          .get<ResponstOfExistentPosts>('v1/replies', { headers: requestHeaders })
          .then((response) => {
            const postsData = response.data.posts
            const formattedPostsData = formatPostsOfMeAndFollower(postsData)
            setPosts(formattedPostsData)
          })
          .catch((error: ErrorStatus) => {
            const { status } = error.response
            if (String(status).indexOf('5') === 0) {
              setErrorMessageInPosts('接続が失われました。確認してからやりなおしてください。')
            } else {
              setErrorMessageInPosts(
                '予期せぬエラーが発生しました。オフラインでないか確認し、それでもエラーが発生する場合はお問い合わせフォームにて問い合わせ下さい。',
              )
            }
          })
          .finally(() => {
            setLoading(false)
          })
        break
      case 'ロック':
        axiosBase
          .get<ResponstOfExistentPosts>('v1/locks', { headers: requestHeaders })
          .then((response) => {
            const postsData = response.data.posts
            const formattedPostsData = formatPostsOfMeAndFollower(postsData)
            setPosts(formattedPostsData)
          })
          .catch((error: ErrorStatus) => {
            const { status } = error.response
            if (String(status).indexOf('5') === 0) {
              setErrorMessageInPosts('接続が失われました。確認してからやりなおしてください。')
            } else {
              setErrorMessageInPosts(
                '予期せぬエラーが発生しました。オフラインでないか確認し、それでもエラーが発生する場合はお問い合わせフォームにて問い合わせ下さい。',
              )
            }
          })
          .finally(() => {
            setLoading(false)
          })
        break
      case 'いいね':
        axiosBase
          .get<ResponstOfExistentPosts>('v1/likes', { headers: requestHeaders })
          .then((response) => {
            const postsData = response.data.posts
            const formattedPostsData = formatPostsOfMeAndFollower(postsData)
            setPosts(formattedPostsData)
          })
          .catch((error: ErrorStatus) => {
            const { status } = error.response
            if (String(status).indexOf('5') === 0) {
              setErrorMessageInPosts('接続が失われました。確認してからやりなおしてください。')
            } else {
              setErrorMessageInPosts(
                '予期せぬエラーが発生しました。オフラインでないか確認し、それでもエラーが発生する場合はお問い合わせフォームにて問い合わせ下さい。',
              )
            }
          })
          .finally(() => {
            setLoading(false)
          })
        break

      default:
        setErrorMessageInPosts(
          '予期せぬエラーが発生しました。オフラインでないか確認し、それでもエラーが発生する場合はお問い合わせフォームにて問い合わせ下さい。',
        )
        setLoading(false)

        break
    }
  }

  return { getPostsInProfile, posts, loading, errorMessageInPosts }
}

export default usePostsInProfile
