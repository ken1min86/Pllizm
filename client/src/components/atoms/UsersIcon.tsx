import { push } from 'connected-react-router';
import { VFC } from 'react';
import { useDispatch } from 'react-redux';

import { Avatar } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

const useStyles = makeStyles(() =>
  createStyles({
    img: {
      width: 44,
      height: 44,
      display: 'block',
      borderRadius: '50%',
    },
  }),
)

type Proos = {
  icon: string
  userId?: string
  disableAllOnClick?: boolean
}

const UsersIcon: VFC<Proos> = ({ userId, icon, disableAllOnClick = false }) => {
  const classes = useStyles()
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
          <Avatar className={classes.img} src={icon} alt="アイコン" />
        </button>
      )}
      {!isOnymousUser && <Avatar className={classes.img} src={icon} alt="アイコン" />}
    </>
  )
}

export default UsersIcon
