import { PostPopover, UsersIcon } from 'components/atoms';
import { createTimeToDisplay } from 'function/common';
import { VFC } from 'react';

import ChatBubbleOutlineRoundedIcon from '@mui/icons-material/ChatBubbleOutlineRounded';
import FavoriteIcon from '@mui/icons-material/Favorite';
import FavoriteBorderOutlinedIcon from '@mui/icons-material/FavoriteBorderOutlined';
import LockIcon from '@mui/icons-material/Lock';
import LockOpenOutlinedIcon from '@mui/icons-material/LockOpenOutlined';
import { Box, IconButton, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    container: {
      backgroundColor: theme.palette.primary.main,
      padding: '16px 32px 24px 16px',
      width: '100%',
      borderBottom: 'solid 1px #EEEEEE',
    },
    img: {
      maxWidth: '100%',
      maxHeight: 300,
      display: 'block',
    },
    content: {
      fontSize: 15,
      display: 'block',
      marginBottom: 8,
    },
    icon: {
      width: 18,
      height: 18,
      marginRight: 8,
    },
    count: {
      display: 'block',
      fontSize: 14,
      color: theme.palette.text.disabled,
    },
    time: {
      fontSize: 14,
      color: theme.palette.text.disabled,
      marginLeft: 'auto',
    },
    settingButton: {
      width: 18,
    },
    userName: {
      fontWeight: 'bold',
      marginRight: 8,
      fontSize: 15,
    },
    userId: {
      fontSize: 14,
      color: theme.palette.text.disabled,
    },
  }),
)

type Props = {
  type: 'me' | 'follower' | 'not-follower' | undefined
  icon: string
  userId?: string
  userName?: string
  postId: string
  content: string
  repliesCount: number
  likesCount?: number
  likedByMe: boolean
  postedAt: string
  locked?: boolean
  image?: string
}

const PostBox: VFC<Props> = ({
  type,
  icon,
  userId,
  userName,
  postId,
  content,
  repliesCount,
  likesCount,
  likedByMe,
  postedAt,
  locked,
  image,
}) => {
  const classes = useStyles()
  const timeToDisplay = createTimeToDisplay(postedAt)

  return (
    <Box className={classes.container}>
      <Box sx={{ display: 'flex', width: '100%' }}>
        <Box mr={2}>
          <UsersIcon userId={userId} icon={icon} />
        </Box>
        <Box sx={{ width: '100%' }}>
          <Box mb={3}>
            {userName != null && (
              <>
                <span className={classes.userName}>{userName}</span>
                <span className={classes.userId}>@{userId}</span>
              </>
            )}
            <span className={classes.content}>{content}</span>
            {image != null && <img src={image} alt="投稿画像" className={classes.img} />}
          </Box>
          <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginLeft: -1 }}>
            <Box sx={{ display: 'flex', alignItems: 'center' }}>
              <IconButton>
                <ChatBubbleOutlineRoundedIcon className={classes.icon} />
                {repliesCount !== 0 && <span className={classes.count}>{repliesCount}</span>}
              </IconButton>
              <IconButton>
                {likedByMe && <FavoriteIcon sx={{ color: '#e0245e' }} className={classes.icon} />}
                {!likedByMe && <FavoriteBorderOutlinedIcon className={classes.icon} />}
                {likesCount !== 0 && <span className={classes.count}>{likesCount}</span>}
              </IconButton>
              <IconButton>
                {locked && <LockIcon className={classes.icon} sx={{ color: '#E59500' }} />}
                {locked != null && !locked && <LockOpenOutlinedIcon className={classes.icon} />}
              </IconButton>
            </Box>
            <Box sx={{ display: 'flex', alignItems: 'center' }}>
              <span className={classes.time}>{timeToDisplay}</span>
              <Box className={classes.settingButton}>{type === 'me' && <PostPopover postId={postId} />}</Box>
            </Box>
          </Box>
        </Box>
      </Box>
    </Box>
  )
}
export default PostBox
