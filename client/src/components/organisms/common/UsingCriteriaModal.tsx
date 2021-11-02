import { FollowRelatedButton, OutlinedRoundedCornerButton } from 'components/atoms';
import { push } from 'connected-react-router';
import useSearchUsers from 'hooks/useSearchUsers';
import { useEffect, useState, VFC } from 'react';
import { useDispatch } from 'react-redux';

import { Avatar, Box, Modal, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    container: {
      position: 'absolute',
      top: '50%',
      left: '50%',
      transform: 'translate(-50%, -50%)',
      backgroundColor: theme.palette.primary.main,
      padding: '32px 24px',
      borderRadius: 4,
      width: 'min(360px, 90vw)',
    },
    title: {
      fontSize: 20,
      fontWeight: 'bold',
      marginBottom: 32,
    },
    description: {
      fontSize: 14,
      display: 'inline-block',
    },
    userName: {
      fontSize: 14,
      marginRight: 4,
    },
    userId: {
      fontSize: 12,
      color: theme.palette.text.disabled,
    },
    bio: {
      fontSize: 12,
    },
  }),
)

const UsingCriteriaModal: VFC = () => {
  const classes = useStyles()

  const dispatch = useDispatch()

  const [open, setOpen] = useState(true)
  const handleClose = () => setOpen(false)

  const { getSearchedUsers: getSearchedUsers1, searchedUsers: searchedUsers1 } = useSearchUsers('ken10806')
  const { getSearchedUsers: getSearchedUsers2, searchedUsers: searchedUsers2 } = useSearchUsers('jun_okada')
  const searchedUsersToDisplay = [searchedUsers1[0], searchedUsers2[0]]

  const handleClickUserIcon = (userId: string) => {
    handleClose()
    dispatch(push(`/users/${userId}`))
  }

  useEffect(() => {
    getSearchedUsers1()
    getSearchedUsers2()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  return (
    <Box>
      <Modal open={open} onClose={handleClose}>
        <Box className={classes.container}>
          <h2 className={classes.title}>2人以上フォローしましょう</h2>
          <Box component="p" mb={3}>
            <span className={classes.description}>Pllizmを利用するには2人以上フォローする必要があります。</span>
            <span className={classes.description}>試しに利用したい方は、以下の2ユーザーをフォローして下さい。</span>
            <span className={classes.description}>即時にフォロー承認いたします。</span>
          </Box>
          {searchedUsersToDisplay.length > 0 &&
            searchedUsersToDisplay.map(
              (searchedUser) =>
                searchedUser && (
                  <Box sx={{ display: 'flex', alignItems: 'center' }} mb={2} key={searchedUser.user_id}>
                    <button type="button" onClick={() => handleClickUserIcon(searchedUser.user_id)}>
                      <Avatar
                        alt="User to follow"
                        src={searchedUser.image_url}
                        sx={{ width: 44, height: 44, marginRight: 1 }}
                      />
                    </button>
                    <Box sx={{ display: 'flex', flexDirection: 'column' }}>
                      <Box sx={{ display: 'flex' }}>
                        <span className={classes.userName}>{searchedUser.user_name}</span>
                        <span className={classes.userId}>@{searchedUser.user_id}</span>
                      </Box>
                      <span className={classes.bio}>{searchedUser.bio}</span>
                    </Box>
                    <Box sx={{ marginLeft: 'auto' }}>
                      <FollowRelatedButton userId={searchedUser.user_id} initialStatus={searchedUser.relationship} />
                    </Box>
                  </Box>
                ),
            )}
          <Box sx={{ maxWidth: 131, margin: '40px auto 0 auto' }}>
            <OutlinedRoundedCornerButton onClick={handleClose} label="閉じる" color="#2699fb" />
          </Box>
        </Box>
      </Modal>
    </Box>
  )
}

export default UsingCriteriaModal
