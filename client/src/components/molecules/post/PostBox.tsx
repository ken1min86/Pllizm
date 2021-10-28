import { DeletePostPopover, UsersIcon } from 'components/atoms';
import { CreateReplyModal, DisplayUploadedImgModal, LockPostModal } from 'components/organisms';
import { push } from 'connected-react-router';
import { useState, VFC } from 'react';
import { useDispatch } from 'react-redux';
import { likePost, unlikePost } from 'reducks/posts/operations';
import { createTimeToDisplay } from 'util/functions/common';

import FavoriteIcon from '@mui/icons-material/Favorite';
import FavoriteBorderOutlinedIcon from '@mui/icons-material/FavoriteBorderOutlined';
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
    buttonToShowDetail: {
      width: '100%',
    },
    divider: {
      backgroundColor: theme.palette.text.disabled,
      width: 1,
      minHeight: 30,
      height: '100%',
    },
    imgContainer: {
      width: '100%',
      height: 250,
    },
    content: {
      fontSize: 15,
      display: 'block',
      marginBottom: 8,
      wordBreak: 'break-all',
      whiteSpace: 'pre-wrap',
    },
    icon: {
      fontSize: 18,
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
  postedBy: 'me' | 'follower' | 'not_follower' | undefined
  icon?: string
  userId?: string
  userName?: string
  postId: string
  content?: string
  repliesCount: number
  likesCount?: number
  likedByMe: boolean
  postedAt: string
  locked?: boolean
  image?: string
  needDividerOnDisplay?: boolean
  status: 'exist' | 'deleted'
  disableAllOnClick?: boolean
}

const PostBox: VFC<Props> = ({
  postedBy,
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
  needDividerOnDisplay = false,
  status,
  disableAllOnClick = false,
}) => {
  const classes = useStyles()
  const dispatch = useDispatch()

  const timeToDisplay = createTimeToDisplay(postedAt)

  const [isLikedByMe, setIsLikedByMe] = useState(likedByMe)
  const [countOfLikes, setCountOfLikes] = useState(likesCount)

  const handleClickToShowDetail = () => {
    if (!disableAllOnClick) dispatch(push(`/posts/${postId}`))
  }

  const handleClickToUnlike = () => {
    if (!disableAllOnClick) dispatch(unlikePost(postId, setIsLikedByMe, setCountOfLikes, countOfLikes))
  }

  const handleClickToLike = () => {
    if (!disableAllOnClick) dispatch(likePost(postId, setIsLikedByMe, setCountOfLikes, countOfLikes))
  }

  const handleClickToStopPropagation = (event: React.MouseEvent<HTMLElement>) => {
    event.stopPropagation()
  }

  return (
    <Box className={classes.container}>
      {status === 'deleted' && (
        <Box sx={{ textAlign: 'center', padding: 4, color: '#86868b' }}>この投稿は削除されました。</Box>
      )}
      {status === 'exist' && (
        <button type="button" className={classes.buttonToShowDetail} onClick={handleClickToShowDetail}>
          <Box sx={{ display: 'flex', width: '100%' }}>
            <Box
              onClick={handleClickToStopPropagation}
              sx={{ display: 'flex', flexDirection: 'column', marginRight: 2, alignItems: 'center', gap: 0.5 }}
            >
              <UsersIcon userId={userId} icon={icon} disableAllOnClick={disableAllOnClick} />
              {needDividerOnDisplay && <div className={classes.divider} />}
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
                {image && (
                  <Box className={classes.imgContainer} onClick={handleClickToStopPropagation}>
                    <DisplayUploadedImgModal uploadedImgSrc={image} />
                  </Box>
                )}
              </Box>
              <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginLeft: -1 }}>
                <Box sx={{ display: 'flex', alignItems: 'center', gap: 2 }}>
                  <CreateReplyModal
                    repliesCount={repliesCount}
                    repliedPostId={postId}
                    repliedPostContent={content}
                    repliedPostImage={image}
                    repliedUserIcon={icon}
                    repliedUserId={userId}
                    repliedUserName={userName}
                    disableAllOnClick={disableAllOnClick}
                  />
                  <Box sx={{ display: 'flex', alignItems: 'center' }} onClick={handleClickToStopPropagation}>
                    {isLikedByMe && (
                      <IconButton onClick={handleClickToUnlike}>
                        <FavoriteIcon sx={{ color: '#e0245e' }} className={classes.icon} />
                      </IconButton>
                    )}
                    {!isLikedByMe && (
                      <IconButton onClick={handleClickToLike}>
                        <FavoriteBorderOutlinedIcon className={classes.icon} />
                      </IconButton>
                    )}
                    {countOfLikes !== 0 && <span className={classes.count}>{countOfLikes}</span>}
                  </Box>
                  {locked != null && (
                    <LockPostModal locked={locked} postId={postId} disableAllOnClick={disableAllOnClick} />
                  )}
                </Box>
                <Box sx={{ display: 'flex', alignItems: 'center' }}>
                  <span className={classes.time}>{timeToDisplay}</span>
                  <Box className={classes.settingButton} onClick={handleClickToStopPropagation}>
                    {postedBy === 'me' && <DeletePostPopover postId={postId} disableAllOnClick={disableAllOnClick} />}
                  </Box>
                </Box>
              </Box>
            </Box>
          </Box>
        </button>
      )}
    </Box>
  )
}
export default PostBox
