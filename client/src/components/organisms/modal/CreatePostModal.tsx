import { ContainedRoundedCornerButton } from 'components/atoms';
import { CreatePost } from 'components/molecules';
import { useState, VFC } from 'react';
import { useSelector } from 'react-redux';
import { Users } from 'util/types/redux/users';

import TelegramIcon from '@mui/icons-material/Telegram';
import { Box, Button, Fab, Hidden, Modal, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

import { getHasRightToUsePlizm } from '../../../reducks/users/selectors';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    modalContainer: {
      [theme.breakpoints.up('sm')]: {
        maxWidth: '600px',
        minWidth: '580px',
        width: '100%',
        margin: '56px auto',
        maxHeight: '90vh',
      },
      [theme.breakpoints.down('sm')]: {
        width: '95vw',
        height: '100%',
        margin: '56px auto',
      },
    },
    telegramContainer: {
      backgroundColor: theme.palette.info.main,
      borderRadius: 9999,
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      color: theme.palette.primary.light,
      '&:hover': {
        backgroundColor: theme.palette.info.main,
        opacity: '0.7',
        transition: 'all 0.3s ease 0s',
      },
    },
  }),
)

const CreatePostModal: VFC = () => {
  const classes = useStyles()

  const selector = useSelector((state: { users: Users }) => state)
  const hasRightToUsePlizm = getHasRightToUsePlizm(selector)
  const [open, setOpen] = useState(false)

  const handleOpen = () => setOpen(true)
  const handleClose = () => setOpen(false)

  return (
    <Box>
      {hasRightToUsePlizm && (
        <>
          <Button onClick={handleOpen} sx={{ width: '100%', p: 0 }}>
            <Hidden lgDown>
              <ContainedRoundedCornerButton label="投稿する" onClick={handleOpen} backgroundColor="#2699fb" />
            </Hidden>
            <Hidden lgUp>
              <Fab className={classes.telegramContainer} onClick={handleOpen}>
                <TelegramIcon fontSize="large" />
              </Fab>
            </Hidden>
          </Button>
          <Modal open={open} onClose={handleClose}>
            <Box className={classes.modalContainer}>
              <CreatePost handleClose={handleClose} />
            </Box>
          </Modal>
        </>
      )}{' '}
    </Box>
  )
}

export default CreatePostModal
