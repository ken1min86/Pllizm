import { DefaultModalOnlyWithTitle } from 'components/molecules';
import { useState, VFC } from 'react';
import { useDispatch } from 'react-redux';
import { signOut } from 'reducks/users/operations';

import MoreHorizIcon from '@mui/icons-material/MoreHoriz';
import { Box, Hidden, IconButton, Popover, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    iconContainer: {
      marginRight: 8,
      width: 44,
      height: 'auto',
    },
    icon: {
      width: '100%',
      borderRadius: 9999,
    },
    userContainer: {
      display: 'flex',
      flexDirection: 'column',
      textAlign: 'left',
    },
    userName: {
      fontSize: 15,
      color: theme.palette.text.primary,
    },
    userId: {
      fontSize: 15,
      color: theme.palette.text.disabled,
    },
    moreIcon: {
      marginLeft: 32,
    },
    iconButton: {
      borderRadius: 9999,
      display: 'flex',
      '&:hover': {
        borderRadius: 9999,
      },
    },
    iconButtonWithoutIconContainer: {
      display: 'flex',
      alignItems: 'center',
    },
    popover: {
      padding: 16,
      color: theme.palette.primary.light,
      backgroundColor: '#333333',
      fontWeight: 'bold',
      fontSize: 14,
    },
  }),
)

type Props = {
  userName: string
  userId: string
  icon: string
}

const AccountLogoutPopover: VFC<Props> = ({ userName, userId, icon }) => {
  const classes = useStyles()
  const dispatch = useDispatch()
  const [anchorEl, setAnchorEl] = useState<HTMLButtonElement | null>(null)

  const handleClick = (event: React.MouseEvent<HTMLButtonElement>) => {
    setAnchorEl(event.currentTarget)
  }

  const handleClose = () => {
    setAnchorEl(null)
  }

  const handleOnClickToSignOut = (setError: React.Dispatch<React.SetStateAction<string>>) => {
    dispatch(signOut(setError))
  }

  const open = Boolean(anchorEl)
  const id = open ? 'simple-popover' : undefined

  return (
    <>
      <Popover
        id={id}
        open={open}
        anchorEl={anchorEl}
        onClose={handleClose}
        anchorOrigin={{
          vertical: 'top',
          horizontal: 'left',
        }}
        transformOrigin={{
          vertical: 'bottom',
          horizontal: 'left',
        }}
      >
        <DefaultModalOnlyWithTitle
          title="ログアウトしますか？"
          actionButtonLabel="ログアウト"
          closeButtonLabel="キャンセル"
          handleOnClick={handleOnClickToSignOut}
          backgroundColorOfActionButton="#2699fb"
        >
          <span>@{userId}からログアウト</span>
        </DefaultModalOnlyWithTitle>
      </Popover>
      <IconButton className={classes.iconButton} onClick={handleClick}>
        <Box className={classes.iconContainer}>
          <img className={classes.icon} src={icon} alt="アイコン" />
        </Box>
        <Hidden lgDown>
          <Box className={classes.iconButtonWithoutIconContainer}>
            <Box className={classes.userContainer}>
              <Box className={classes.userName} component="span">
                {userName}
              </Box>
              <Box className={classes.userId} component="span">
                @{userId}
              </Box>
            </Box>
            <MoreHorizIcon className={classes.moreIcon} />
          </Box>
        </Hidden>
      </IconButton>
    </>
  )
}

export default AccountLogoutPopover
