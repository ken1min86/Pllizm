import { push } from 'connected-react-router';
import { VFC } from 'react';
import { useDispatch } from 'react-redux';

import { Avatar } from '@mui/material';

type Proos = {
  icon?: string
  userId?: string
  disableAllOnClick?: boolean
}

const UsersIcon: VFC<Proos> = ({ userId, icon, disableAllOnClick = false }) => {
  const dispatch = useDispatch()

  const isOnymousUser = userId != null

  const handleOnClick = () => {
    // eslint-disable-next-line @typescript-eslint/restrict-template-expressions
    if (!disableAllOnClick) dispatch(push(`/users/${userId}`))
  }

  return (
    <>
      {isOnymousUser && (
        <button type="button" onClick={handleOnClick}>
          <Avatar src={icon} alt="アイコン" sx={{ width: 44, height: 44 }} />
        </button>
      )}
      {!isOnymousUser && <Avatar src={icon} alt="アイコン" sx={{ width: 44, height: 44 }} />}
    </>
  )
}

export default UsersIcon
