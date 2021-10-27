import { push } from 'connected-react-router';
import { VFC } from 'react';
import { useDispatch } from 'react-redux';

import { Avatar, Box, Divider, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

import Logo from '../../assets/img/LogoLarge.png';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    refractLogo: {
      width: 24,
      height: 24,
      marginRight: 8,
    },
    description: {
      marginBottom: 16,
      [theme.breakpoints.down('sm')]: {
        fontSize: 14,
      },
    },
    postContent: {
      color: theme.palette.text.disabled,
      [theme.breakpoints.down('sm')]: {
        fontSize: 12,
      },
    },
  }),
)

type Props = {
  userIcon: string
  userName: string
  postContent: string
}

const NotificationOfRefract: VFC<Props> = ({ userIcon, userName, postContent }) => {
  const classes = useStyles()
  const dispatch = useDispatch()

  const handleClick = () => {
    dispatch(push('/refracted_posts'))
  }

  return (
    <Box component="button" type="button" onClick={handleClick} sx={{ width: '100%' }}>
      <Box sx={{ display: 'flex', padding: 2 }}>
        <img src={Logo} alt="Refract Logo" className={classes.refractLogo} />
        <Box sx={{ display: 'flex', flexDirection: 'column' }}>
          <Avatar src={userIcon} alt="User icon" sx={{ width: 28, height: 28, marginBottom: 1 }} />
          <span className={classes.description}>
            <Box component="span" sx={{ fontWeight: 'bold' }}>
              {userName}
            </Box>
            さんがあなたの投稿をリフラクトしました。
          </span>
          <span className={classes.postContent}>{postContent}</span>
        </Box>
      </Box>
      <Divider />
    </Box>
  )
}

export default NotificationOfRefract
