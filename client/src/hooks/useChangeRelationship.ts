import { useState } from 'react';
import { useSelector } from 'react-redux';
import { getUser } from 'reducks/users/selectors';
import { axiosBase } from 'util/api';
import { RequestHeadersForAuthentication } from 'util/types/common';
import { UsersRelationship } from 'util/types/hooks/users';
import { Users } from 'util/types/redux/users';

const useChangeRelationship = (initialStatus: UsersRelationship) => {
  const selector = useSelector((state: { users: Users }) => state)
  const loginUser = getUser(selector)

  const requestHeaders: RequestHeadersForAuthentication = {
    'access-token': loginUser.accessToken,
    client: loginUser.client,
    uid: loginUser.uid,
  }

  const [status, setStatus] = useState<UsersRelationship>(initialStatus)

  const requestFollowing = (userId: string) => {
    void axiosBase
      .post('v1/follow_requests/create', { request_to: `${userId}` }, { headers: requestHeaders })
      .then(() => {
        setStatus('requestingByMe')
      })
  }

  const unfollow = (userId: string) => {
    void axiosBase.delete(`v1/followers/${userId}`, { headers: requestHeaders }).then(() => {
      setStatus('default')
    })
  }

  const acceptFollowRequest = (userId: string) => {
    void axiosBase
      .post('v1/follow_requests/accept', { follow_to: `${userId}` }, { headers: requestHeaders })
      .then(() => {
        setStatus('following')
      })
  }

  const refuseFollowRequest = (userId: string) => {
    void axiosBase
      .delete('v1/follow_requests/refuse', { params: { requested_by: `${userId}` }, headers: requestHeaders })
      .then(() => {
        setStatus('default')
      })
  }

  const cancelFollowRequest = (userId: string) => {
    void axiosBase
      .delete('v1/follow_requests/outgoing', { params: { request_to: `${userId}` }, headers: requestHeaders })
      .then(() => {
        setStatus('default')
      })
  }

  return {
    requestFollowing,
    unfollow,
    acceptFollowRequest,
    refuseFollowRequest,
    cancelFollowRequest,
    status,
    setStatus,
  }
}

export default useChangeRelationship
