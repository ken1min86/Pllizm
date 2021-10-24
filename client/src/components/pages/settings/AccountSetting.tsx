import { BottomNavigationBar, HeaderWithBackAndTitle } from 'components/molecules';
import { DefaultTemplate } from 'components/templates';
import { push } from 'connected-react-router';
import { VFC } from 'react';
import { useDispatch } from 'react-redux';

import DeleteOutlineOutlinedIcon from '@mui/icons-material/DeleteOutlineOutlined';
import EmailOutlinedIcon from '@mui/icons-material/EmailOutlined';
import PersonOutlineOutlinedIcon from '@mui/icons-material/PersonOutlineOutlined';
import VpnKeyOutlinedIcon from '@mui/icons-material/VpnKeyOutlined';
import { List, ListItemButton, ListItemText } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

const useStyles = makeStyles(() =>
  createStyles({
    listItem: {
      padding: 12,
    },
    icon: {
      width: 27.5,
      height: 27.5,
      marginRight: 16,
    },
  }),
)

const AccountSetting: VFC = () => {
  const classes = useStyles()
  const dispatch = useDispatch()

  const Header = <HeaderWithBackAndTitle title="設定" />
  const Bottom = <BottomNavigationBar activeNav="settings" />

  return (
    <DefaultTemplate activeNavTitle="settings" Header={Header} Bottom={Bottom}>
      <List component="nav" aria-label="Account settings">
        <ListItemButton
          className={classes.listItem}
          divider
          onClick={() => {
            dispatch(push('/settings/user_id'))
          }}
        >
          <PersonOutlineOutlinedIcon className={classes.icon} />
          <ListItemText primary="ユーザーID変更" />
        </ListItemButton>
        <ListItemButton
          className={classes.listItem}
          divider
          onClick={() => {
            dispatch(push('/settings/email'))
          }}
        >
          <EmailOutlinedIcon className={classes.icon} />
          <ListItemText primary="メールアドレス変更" />
        </ListItemButton>
        <ListItemButton
          className={classes.listItem}
          divider
          onClick={() => {
            dispatch(push('/settings/password'))
          }}
        >
          <VpnKeyOutlinedIcon className={classes.icon} />
          <ListItemText primary="パスワード変更" />
        </ListItemButton>
        <ListItemButton
          className={classes.listItem}
          divider
          onClick={() => {
            dispatch(push('/settings/deactivate'))
          }}
        >
          <DeleteOutlineOutlinedIcon className={classes.icon} sx={{ color: '#e0245e' }} />
          <ListItemText primary="アカウント削除" sx={{ color: '#e0245e' }} />
        </ListItemButton>
      </List>
    </DefaultTemplate>
  )
}

export default AccountSetting
