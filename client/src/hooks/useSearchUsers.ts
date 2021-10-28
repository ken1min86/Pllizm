import { useState } from 'react';
import { useSelector } from 'react-redux';
import { getUser } from 'reducks/users/selectors';
import { axiosBase } from 'util/api';
import { RequestHeadersForAuthentication } from 'util/types/common';
import { FormattedSearchedUser, ReponseOfSearchedUsers } from 'util/types/hooks/users';
import { Users } from 'util/types/redux/users';

const useSearchUsers = (query: string) => {
  const selector = useSelector((state: { users: Users }) => state)

  const [loading, setLoading] = useState(false)
  const [searchedUsers, setSearchedUsers] = useState<Array<FormattedSearchedUser>>([])

  const getSearchedUsers = () => {
    setLoading(true)
    if (!query) {
      setSearchedUsers([])
      setLoading(false)

      return
    }
    const user = getUser(selector)
    const requestHeaders: RequestHeadersForAuthentication = {
      'access-token': user.accessToken,
      client: user.client,
      uid: user.uid,
    }
    axiosBase
      .get<ReponseOfSearchedUsers>(`/v1/search/users?q=${query}`, { headers: requestHeaders })
      .then((response) => {
        const responseUsers = response.data.users
        const formattedUsers = responseUsers.map((responseUser) => {
          const formattedUser: FormattedSearchedUser = {
            user_id: responseUser.user_id,
            user_name: responseUser.user_name,
            image_url: responseUser.image_url,
            bio: responseUser.bio,
            relationship: 'default',
          }
          switch (responseUser.relationship) {
            case 'none':
              formattedUser.relationship = 'default'
              break
            case 'following':
              formattedUser.relationship = 'following'
              break
            case 'request_follow_to_me':
              formattedUser.relationship = 'requestedToMe'
              break
            case 'requested_follow_by_me':
              formattedUser.relationship = 'requestingByMe'
              break
            case 'current_user':
              formattedUser.relationship = 'currentUser'
              break
            default:
              throw new Error('レスポンスデータに想定外の値が含まれました。')
          }

          return formattedUser
        })
        setSearchedUsers(formattedUsers)
      })
      .catch((errors) => {
        console.log(errors)
      })
      .finally(() => {
        setLoading(false)
      })
  }

  return { getSearchedUsers, loading, searchedUsers }
}

export default useSearchUsers
