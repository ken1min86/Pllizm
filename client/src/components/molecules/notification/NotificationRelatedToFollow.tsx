import { push } from 'connected-react-router';
import { VFC } from 'react';
import { useDispatch } from 'react-redux';

import PersonIcon from '@mui/icons-material/Person';
import { Avatar, Box, Divider, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    description: {
      marginBottom: 16,
      [theme.breakpoints.down('sm')]: {
        fontSize: 14,
      },
    },
  }),
)

type Props = {
  action: 'request' | 'accept'
  userIcon: string
  userId: string
  userName: string
}

const NotificationRelatedToFollow: VFC<Props> = ({ action, userId, userIcon, userName }) => {
  const classes = useStyles()
  const dispatch = useDispatch()

  const handleClick = () => {
    dispatch(push(`users/${userId}`))
  }

  return (
    <Box component="button" type="button" onClick={handleClick} sx={{ width: '100%' }}>
      <Box sx={{ display: 'flex', padding: 2 }}>
        {action === 'request' && <PersonIcon color="warning" sx={{ marginRight: 1, color: '#e0245e' }} />}
        {action === 'accept' && <PersonIcon color="info" sx={{ marginRight: 1 }} />}
        <Box sx={{ display: 'flex', flexDirection: 'column' }}>
          <Avatar src={userIcon} alt="User icon" sx={{ width: 28, height: 28, marginBottom: 1 }} />
          {action === 'request' && (
            <span className={classes.description}>
              <Box component="span" sx={{ fontWeight: 'bold' }}>
                {userName}
              </Box>
              さんからフォローリクエストがきています。
            </span>
          )}
          {action === 'accept' && (
            <span className={classes.description}>
              <Box component="span" sx={{ fontWeight: 'bold' }}>
                {userName}
              </Box>
              さんにフォロー承認されました。
            </span>
          )}
        </Box>
      </Box>
      <Divider />
    </Box>
  )
}

export default NotificationRelatedToFollow
