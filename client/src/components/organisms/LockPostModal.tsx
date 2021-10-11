import { ContainedRoundedCornerButton } from 'components/atoms';
import { useState, VFC } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { changeLockStateOfPost } from 'reducks/posts/operations';
import { disableLockDescription } from 'reducks/users/operations';
import { getNeedDescriptionAboutLock } from 'reducks/users/selectors';
import { Users } from 'reducks/users/types';

import LockIcon from '@mui/icons-material/Lock';
import LockOpenOutlinedIcon from '@mui/icons-material/LockOpenOutlined';
import { Box, Checkbox, FormControlLabel, IconButton, Modal, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

// eslint-disable-next-line import/no-useless-path-segments
import { RefractFuncDescriptionModal } from './';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    modalContainer: {
      padding: '32px 24px 16px 24px',
      backgroundColor: theme.palette.primary.main,
      borderRadius: 8,
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      maxWidth: 327,
    },
    title: {
      fontSize: 20,
      fontWeight: 'bold',
      marginBottom: 24,
    },
    contentContainer: {
      marginBottom: 32,
      fontSize: 15,
    },
    content: {
      display: 'inline-block',
      marginBottom: 4,
    },
  }),
)

type Props = {
  locked: boolean
  postId: string
}

const LockPostModal: VFC<Props> = ({ locked, postId }) => {
  const classes = useStyles()
  const dispatch = useDispatch()
  const selector = useSelector((state: { users: Users }) => state)

  const needDescriptionAboutLock = getNeedDescriptionAboutLock(selector)

  const [open, setOpen] = useState(false)
  const [doNotShowFuture, setDoNotShowFuture] = useState(false)
  const [isLocked, setIsLocked] = useState(locked)

  const handleClose = () => {
    setOpen(false)
    setDoNotShowFuture(false)
  }

  const handleClickIconToLock = () => {
    if (needDescriptionAboutLock) {
      setOpen(true)
    } else {
      dispatch(changeLockStateOfPost(postId, isLocked, setIsLocked))
    }
  }

  const handleDoNotShow = () => {
    setDoNotShowFuture(!doNotShowFuture)
  }

  const handleCloseButton = () => {
    if (doNotShowFuture) {
      dispatch(disableLockDescription())
    }
    handleClose()
  }

  const handleClickButtonToLock = () => {
    if (doNotShowFuture) {
      dispatch(disableLockDescription())
    }
    dispatch(changeLockStateOfPost(postId, isLocked, setIsLocked))
    handleClose()
  }

  return (
    <>
      <IconButton aria-label="change lock state" onClick={handleClickIconToLock}>
        {isLocked && <LockIcon fontSize="small" sx={{ color: '#E59500' }} />}
        {!isLocked && <LockOpenOutlinedIcon fontSize="small" />}
      </IconButton>
      <Modal
        open={open}
        onClose={handleClose}
        sx={{ paddingRight: 3, paddingLeft: 3, display: 'flex', justifyContent: 'center', alignItems: 'center' }}
      >
        <Box className={classes.modalContainer}>
          <LockIcon sx={{ fontSize: 56, marginBottom: 2 }} />
          <h2 className={classes.title}>ロック機能とは</h2>
          <p className={classes.contentContainer}>
            <span className={classes.content}>ユーザーの情報を開示しないようにする機能です。</span>
            <span className={classes.content}>
              ロックした投稿は、<small>※</small>リフラクトされません。
            </span>
          </p>
          <Box sx={{ marginRight: 'auto' }}>
            <FormControlLabel
              control={<Checkbox sx={{ color: '#000' }} color="secondary" size="small" />}
              label="今後は表示しない"
              sx={{ marginBottom: 2 }}
              onChange={handleDoNotShow}
            />
          </Box>
          <Box sx={{ display: 'flex', width: '100%', justifyContent: 'space-between' }} mb={2}>
            <Box sx={{ width: '48%' }}>
              <ContainedRoundedCornerButton onClick={handleCloseButton} label="閉じる" backgroundColor="#86868b" />
            </Box>
            <Box sx={{ width: '48%' }}>
              {isLocked && (
                <ContainedRoundedCornerButton
                  onClick={handleClickButtonToLock}
                  label="ロック解除する"
                  backgroundColor="#2699fb"
                />
              )}
              {!isLocked && (
                <ContainedRoundedCornerButton
                  onClick={handleClickButtonToLock}
                  label="ロックする"
                  backgroundColor="#2699fb"
                />
              )}
            </Box>
          </Box>
          <Box sx={{ marginLeft: 'auto' }}>
            <RefractFuncDescriptionModal type="text" />
          </Box>
        </Box>
      </Modal>
    </>
  )
}

export default LockPostModal
