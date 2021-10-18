import { DefaultTemplate } from 'components/templates';
import { goBack } from 'connected-react-router';
import { useDispatch } from 'react-redux';

import ArrowBackIcon from '@mui/icons-material/ArrowBack';
import DeleteOutlineOutlinedIcon from '@mui/icons-material/DeleteOutlineOutlined';
import EmailOutlinedIcon from '@mui/icons-material/EmailOutlined';
import PersonOutlineOutlinedIcon from '@mui/icons-material/PersonOutlineOutlined';
import VpnKeyOutlinedIcon from '@mui/icons-material/VpnKeyOutlined';
import { Box, IconButton, List, ListItem, ListItemText, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    title: {
      color: theme.palette.primary.main,
      fontSize: 22,
      fontWeight: 'bold',
    },
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

const AccountSetting = () => {
  const classes = useStyles()
  const dispatch = useDispatch()

  const handleClickToBack = () => {
    dispatch(goBack())
  }

  const returnHeaderFunc = () => (
    <Box sx={{ display: 'flex', alignItems: 'center' }}>
      <IconButton aria-label="Back" sx={{ marginLeft: 0.5, marginRight: 1 }} onClick={handleClickToBack}>
        <ArrowBackIcon sx={{ color: '#2699fb' }} />
      </IconButton>
      <h1 className={classes.title}>設定</h1>
    </Box>
  )

  return (
    <DefaultTemplate activeNavTitle="settings" returnHeaderFunc={returnHeaderFunc}>
      <List component="nav" aria-label="Account settings">
        <ListItem button className={classes.listItem} divider>
          <PersonOutlineOutlinedIcon className={classes.icon} />
          <ListItemText primary="ユーザーID変更" />
        </ListItem>
        <ListItem button className={classes.listItem} divider>
          <EmailOutlinedIcon className={classes.icon} />
          <ListItemText primary="メールアドレス変更" />
        </ListItem>
        <ListItem button className={classes.listItem} divider>
          <VpnKeyOutlinedIcon className={classes.icon} />
          <ListItemText primary="パスワード変更" />
        </ListItem>
        <ListItem button className={classes.listItem} divider>
          <DeleteOutlineOutlinedIcon className={classes.icon} sx={{ color: '#e0245e' }} />
          <ListItemText primary="アカウント削除" sx={{ color: '#e0245e' }} />
        </ListItem>
      </List>
    </DefaultTemplate>
  )
}

export default AccountSetting
