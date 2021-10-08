import { DefaultModalOnlyWithTitle } from 'components/molecules';
import { useState, VFC } from 'react';
import { useDispatch } from 'react-redux';
import { deletePost } from 'reducks/posts/operations';

import DeleteOutlinedIcon from '@mui/icons-material/DeleteOutlined';
import MoreHorizIcon from '@mui/icons-material/MoreHoriz';
import { Box, IconButton, Popover, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    deleteButtonContainer: {
      display: 'flex',
      alignItems: 'center',
      color: theme.palette.primary.light,
      backgroundColor: '#333333',
      fontWeight: 'bold',
      fontSize: 14,
      padding: '0 16px 0 8px',
      '&:hover': {
        backgroundColor: '#333333',
        opacity: '0.7',
        transition: 'all 0.3s ease 0s',
      },
    },
  }),
)

type Props = {
  postId: string
}

const DeletePostPopover: VFC<Props> = ({ postId }) => {
  const classes = useStyles()
  const dispatch = useDispatch()

  const [anchorEl, setAnchorEl] = useState<EventTarget & HTMLElement>()
  const open = Boolean(anchorEl)
  const id = open ? 'simple-popover' : undefined

  const handleClick = (event: React.MouseEvent<HTMLElement>) => {
    setAnchorEl(event.currentTarget)
  }

  const handleClose = () => {
    setAnchorEl(undefined)
  }

  const handleDelete = () => {
    dispatch(deletePost(postId))
  }

  return (
    <>
      <IconButton aria-describedby={id} onClick={handleClick}>
        <MoreHorizIcon />
      </IconButton>
      <Popover
        id={id}
        open={open}
        anchorEl={anchorEl}
        onClose={handleClose}
        anchorOrigin={{
          vertical: 'top',
          horizontal: 'right',
        }}
        transformOrigin={{
          vertical: 'top',
          horizontal: 'right',
        }}
      >
        <DefaultModalOnlyWithTitle
          title="投稿を削除しますか？"
          actionButtonLabel="削除"
          closeButtonLabel="キャンセル"
          handleOnClick={handleDelete}
          backgroundColorOfActionButton="#e0245e"
        >
          <Box className={classes.deleteButtonContainer}>
            <DeleteOutlinedIcon sx={{ color: '#e0245e', marginRight: 1 }} />
            <span>削除</span>
          </Box>
        </DefaultModalOnlyWithTitle>
      </Popover>
    </>
  )
}

export default DeletePostPopover
