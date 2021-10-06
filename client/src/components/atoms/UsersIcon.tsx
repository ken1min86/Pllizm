import { push } from 'connected-react-router';
import { VFC } from 'react';
import { useDispatch } from 'react-redux';

import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

const useStyles = makeStyles(() =>
  createStyles({
    img: {
      width: 44,
      display: 'block',
      borderRadius: '50%',
    },
  }),
)

type Proos = {
  icon: string
  userId?: string
}

const UsersIcon: VFC<Proos> = ({ userId, icon }) => {
  const classes = useStyles()
  const dispatch = useDispatch()

  const isOnymousUser = userId != null

  const handleOnClick = () => {
    // eslint-disable-next-line @typescript-eslint/restrict-template-expressions
    dispatch(push(`/${userId}`))
  }

  return (
    <>
      {isOnymousUser && (
        <button type="button" onClick={handleOnClick}>
          <img className={classes.img} src={icon} alt="アイコン" />
        </button>
      )}
      {!isOnymousUser && <img className={classes.img} src={icon} alt="アイコン" />}
    </>
  )
}

export default UsersIcon
