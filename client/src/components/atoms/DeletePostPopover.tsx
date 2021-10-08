import { useState, VFC } from 'react';

import DeleteOutlinedIcon from '@mui/icons-material/DeleteOutlined';
import MoreHorizIcon from '@mui/icons-material/MoreHoriz';
import { Box, IconButton, Popover, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    deleteButton: {
      color: theme.palette.primary.light,
      backgroundColor: '#333333',
      fontWeight: 'bold',
      fontSize: 14,
    },
  }),
)

type Proos = {
  postId: string
}

const DeletePostPopover: VFC<Proos> = ({ postId }) => {
  const classes = useStyles()
  const [anchorEl, setAnchorEl] = useState(null)

  const handleClick = (event: any) => {
    // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
    setAnchorEl(event.currentTarget)
  }

  const handleClose = () => {
    setAnchorEl(null)
  }

  const handleDelete = () => {
    console.log(postId)
    console.log('投稿削除機能実装時に修正。削除確認モーダルを表示させる。')
  }

  const open = Boolean(anchorEl)
  const id = open ? 'simple-popover' : undefined

  return (
    <>
      {/* <Button aria-describedby={id} variant="contained" onClick={handleClick}>
        Open Popover
      </Button> */}
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
        <Box
          onClick={handleDelete}
          className={classes.deleteButton}
          sx={{ padding: '16px 72px 16px 16px', backgroundColor: '#f9f4ef', display: 'flex', alignItems: 'center' }}
        >
          <DeleteOutlinedIcon sx={{ color: '#e0245e', marginRight: 1 }} />
          <span>削除</span>
        </Box>
      </Popover>
    </>
  )
}

export default DeletePostPopover
