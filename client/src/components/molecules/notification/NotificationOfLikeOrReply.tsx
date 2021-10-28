import { push } from 'connected-react-router';
import { VFC } from 'react';
import { useDispatch } from 'react-redux';

import ChatBubbleOutlineRoundedIcon from '@mui/icons-material/ChatBubbleOutlineRounded';
import FavoriteIcon from '@mui/icons-material/Favorite';
import { Box, Divider, Theme } from '@mui/material';
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
    postContent: {
      color: theme.palette.text.disabled,
      [theme.breakpoints.down('sm')]: {
        fontSize: 12,
      },
    },
  }),
)

type Props = {
  action: 'like' | 'reply'
  postId: string
  postContent: string
}

const NotificationOfLikeOrReply: VFC<Props> = ({ action, postId, postContent }) => {
  const classes = useStyles()
  const dispatch = useDispatch()

  const handleClick = () => {
    dispatch(push(`/posts/${postId}`))
  }

  return (
    <Box component="button" type="button" onClick={handleClick} sx={{ width: '100%' }}>
      <Box sx={{ display: 'flex', padding: 2 }}>
        {action === 'like' && <FavoriteIcon color="warning" sx={{ marginRight: 1 }} />}
        {action === 'reply' && <ChatBubbleOutlineRoundedIcon color="info" sx={{ marginRight: 1 }} />}
        <Box sx={{ display: 'flex', flexDirection: 'column' }}>
          {action === 'like' && <span className={classes.description}>あなたの投稿がいいねされました。</span>}
          {action === 'reply' && <span className={classes.description}>あなたの投稿にリプライがきました。</span>}
          <span className={classes.postContent}>{postContent}</span>
        </Box>
      </Box>
      <Divider />
    </Box>
  )
}

export default NotificationOfLikeOrReply
