import { CreatePost, RepliedPostPreview } from 'components/molecules';
import { useState, VFC } from 'react';

import ChatBubbleOutlineRoundedIcon from '@mui/icons-material/ChatBubbleOutlineRounded';
import { Box, IconButton, Modal, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

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
    count: {
      display: 'block',
      fontSize: 14,
      color: theme.palette.text.disabled,
    },
  }),
)

type Props = {
  repliesCount: number
  repliedPostId: string
  repliedPostContent?: string
  repliedUserIcon?: string
  repliedPostImage?: string
  repliedUserId?: string
  repliedUserName?: string
  disableAllOnClick?: boolean
}

const CreateReplyModal: VFC<Props> = ({
  repliesCount,
  repliedPostId,
  repliedPostContent,
  repliedPostImage,
  repliedUserIcon,
  repliedUserId,
  repliedUserName,
  disableAllOnClick = false,
}) => {
  const classes = useStyles()

  const [open, setOpen] = useState(false)

  const handleOpen = () => {
    if (!disableAllOnClick) setOpen(true)
  }

  const handleClose = () => {
    setOpen(false)
  }

  const handleClickToStopPropagation = (event: React.MouseEvent<HTMLElement>) => {
    event.stopPropagation()
  }

  return (
    <Box onClick={handleClickToStopPropagation}>
      <Box sx={{ display: 'flex', alignItems: 'center' }}>
        <IconButton onClick={handleOpen}>
          <ChatBubbleOutlineRoundedIcon sx={{ fontSize: 18 }} />
        </IconButton>
        {repliesCount !== 0 && <span className={classes.count}>{repliesCount}</span>}
      </Box>
      <Modal open={open} onClose={handleClose}>
        <Box className={classes.modalContainer}>
          <CreatePost handleClose={handleClose} repliedPostId={repliedPostId}>
            <RepliedPostPreview
              content={repliedPostContent}
              image={repliedPostImage}
              icon={repliedUserIcon}
              userId={repliedUserId}
              userName={repliedUserName}
            />
          </CreatePost>
        </Box>
      </Modal>
    </Box>
  )
}

export default CreateReplyModal
