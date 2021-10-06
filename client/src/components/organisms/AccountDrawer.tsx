import { ErrorMessages } from 'components/atoms';
import { push } from 'connected-react-router';
import { useState, VFC } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { signOut } from 'reducks/users/operations';
import { Users } from 'reducks/users/types';

import ExitToAppIcon from '@mui/icons-material/ExitToApp';
import PersonOutlineOutlinedIcon from '@mui/icons-material/PersonOutlineOutlined';
import SettingsOutlinedIcon from '@mui/icons-material/SettingsOutlined';
import {
    Avatar, Box, Button, Divider, List, ListItem, ListItemIcon, ListItemText, SwipeableDrawer, Theme
} from '@mui/material';
// import { Theme, Button } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

import { getIcon, getUserId, getUserName } from '../../reducks/users/selectors';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    accountIcon: {
      position: 'relative',
      marginLeft: 8,
      width: 28,
      borderRadius: '50%',
    },
    drawerContainer: {
      backgroundColor: theme.palette.primary.main,
      width: 280,
      height: '100%',
    },
    accountInfoContainer: {
      backgroundColor: '#333333',
      color: theme.palette.primary.main,
      padding: 16,
      display: 'flex',
      flexDirection: 'column',
    },
    userName: {
      fontSize: 15,
    },
    userId: {
      fontSize: 12,
    },
  }),
)

type Anchor = 'left'

const AccountDrawer: VFC = () => {
  const selector = useSelector((state: { users: Users }) => state)
  const userName = getUserName(selector)
  const userId = getUserId(selector)
  const icon = getIcon(selector)
  const classes = useStyles()
  const dispatch = useDispatch()

  const [state, setState] = useState({ left: false })
  const [error, setError] = useState('')

  const handleOnClickToSignOut = () => {
    dispatch(signOut(setError))
  }

  const toggleDrawer = (anchor: Anchor, open: boolean) => (event: React.KeyboardEvent | React.MouseEvent) => {
    if (
      event &&
      event.type === 'keydown' &&
      ((event as React.KeyboardEvent).key === 'Tab' || (event as React.KeyboardEvent).key === 'Shift')
    ) {
      return
    }

    setState({ ...state, [anchor]: open })
  }

  return (
    <>
      <Button onClick={toggleDrawer('left', true)}>
        <img src={icon} alt="アイコン" className={classes.accountIcon} />
      </Button>
      <SwipeableDrawer
        anchor="left"
        open={state.left}
        onClose={toggleDrawer('left', false)}
        onOpen={toggleDrawer('left', true)}
      >
        <Box
          className={classes.drawerContainer}
          role="presentation"
          onClick={toggleDrawer('left', false)}
          onKeyDown={toggleDrawer('left', false)}
        >
          <Box className={classes.accountInfoContainer}>
            <Avatar
              alt="Account Icon"
              src={icon}
              sx={{ width: 36, height: 36, marginBottom: 1 }}
              component="button"
              onClick={() => {
                dispatch(push(`/${userId}`))
              }}
            />
            <span className={classes.userName}>{userName}</span>
            <span className={classes.userId}>@{userId}</span>
          </Box>
          <List>
            <ListItem
              button
              onClick={() => {
                dispatch(push(`/${userId}`))
              }}
            >
              <ListItemIcon>
                <PersonOutlineOutlinedIcon fontSize="large" />
              </ListItemIcon>
              <ListItemText primary="プロフィール" />
            </ListItem>
            <ListItem
              button
              onClick={() => {
                dispatch(push('/settings/account'))
              }}
            >
              <ListItemIcon>
                <SettingsOutlinedIcon fontSize="large" />
              </ListItemIcon>
              <ListItemText primary="設定" />
            </ListItem>
          </List>
          <Divider />
          <List>
            <ListItem button onClick={handleOnClickToSignOut}>
              <ListItemIcon>
                <ExitToAppIcon fontSize="large" />
              </ListItemIcon>
              <ListItemText primary="ログアウト" />
            </ListItem>
            <ListItem>
              <ErrorMessages errors={[error]} />
            </ListItem>
          </List>
        </Box>
      </SwipeableDrawer>
    </>
  )
}

export default AccountDrawer
