import { useState } from 'react';
import { useSelector } from 'react-redux';
import { getUser } from 'reducks/users/selectors';
import { axiosBase } from 'util/api';
import { ReponseOfUsers, RequestHeaders, User } from 'util/types/hooks/users';
import { Users } from 'util/types/redux/users';

const useSearchUsers = (query: string) => {
  const selector = useSelector((state: { users: Users }) => state)

  const [loading, setLoading] = useState(false)
  const [searchedUsers, setSearchedUsers] = useState<Array<User>>([])

  const getSearchedUsers = () => {
    setLoading(true)
    if (!query) {
      setSearchedUsers([])
      setLoading(false)

      return
    }
    const user = getUser(selector)
    const requestHeaders: RequestHeaders = {
      'access-token': user.accessToken,
      client: user.client,
      uid: user.uid,
    }
    axiosBase
      .get<ReponseOfUsers>(`/v1/search/users?q=${query}`, { headers: requestHeaders })
      .then((response) => {
        setSearchedUsers(response.data.users)
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
