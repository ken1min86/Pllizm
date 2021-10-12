import { DisplayUploadedImgModal } from 'components/organisms';
import { VFC } from 'react';

import { Avatar, Box, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    divider: {
      backgroundColor: theme.palette.text.disabled,
      width: 1,
      minHeight: 30,
      height: '100%',
    },
    userName: {
      fontSize: 15,
      marginRight: 8,
    },
    userId: {
      fontSize: 14,
      color: theme.palette.text.disabled,
    },
    content: {
      width: '100%',
      marginBottom: 32,
      whiteSpace: 'pre',
    },
    imageContainer: {
      width: '100%',
      height: 250,
      borderRadius: 16,
      marginBottom: 24,
    },
  }),
)

type Props = {
  content: string
  image?: string
  icon: string
  userId?: string
  userName?: string
}

const RepliedPostPreview: VFC<Props> = ({ content, image, icon, userId, userName }) => {
  const classes = useStyles()

  return (
    <Box sx={{ display: 'flex' }}>
      <Box sx={{ display: 'flex', flexDirection: 'column', marginRight: 2, alignItems: 'center', gap: 0.5 }}>
        <Avatar alt="Replied user icon" src={icon} sx={{ width: 48, height: 48 }} />
        <div className={classes.divider} />
      </Box>
      <Box sx={{ width: '100%', display: 'flex', flexDirection: 'column' }}>
        <Box>
          {userName && <span className={classes.userName}>{userName}</span>}
          {userId && <span className={classes.userId}>@{userId}</span>}
        </Box>
        <p className={classes.content}>{content}</p>
        {image && (
          <Box className={classes.imageContainer}>
            <DisplayUploadedImgModal uploadedImgSrc={image} />
          </Box>
        )}
      </Box>
    </Box>
  )
}

export default RepliedPostPreview
