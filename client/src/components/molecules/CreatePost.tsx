import { ContainedRoundedCornerButton } from 'components/atoms';
import { DisplayUploadedImgModal } from 'components/organisms';
import { useState, VFC } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { submitNewPost } from 'reducks/posts/operations';
import { Users } from 'reducks/users/types';

import AddPhotoAlternateIcon from '@mui/icons-material/AddPhotoAlternate';
import CancelIcon from '@mui/icons-material/Cancel';
import CloseIcon from '@mui/icons-material/Close';
import LockIcon from '@mui/icons-material/Lock';
import LockOpenOutlinedIcon from '@mui/icons-material/LockOpenOutlined';
import { Avatar, Box, Checkbox, Divider, IconButton, TextareaAutosize, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

import { getIcon } from '../../reducks/users/selectors';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    container: {
      width: '100%',
      height: '100%',
      maxHeight: 500,
      borderRadius: 16,
      display: 'flex',
      flexDirection: 'column',
    },
    header: {
      height: 56,
      backgroundColor: '#333333',
      borderRadius: '16px 16px 0 0',
      display: 'flex',
      alignItems: 'center',
    },
    closeDisplayIconButton: {
      marginLeft: 8,
      color: theme.palette.info.main,
    },
    main: {
      padding: 16,
      backgroundColor: theme.palette.primary.main,
      borderRadius: '0 0 16px 16px',
      display: 'flex',
    },
    divider: {
      color: theme.palette.text.secondary,
      marginBottom: 8,
    },
    input: {
      display: 'none',
    },
    displayUploadedImgContainer: {
      width: '100%',
      height: 250,
      borderRadius: 16,
      marginBottom: 24,
    },
    textCounter: {
      fontSize: 13,
      display: 'inline-block',
      marginLeft: 'auto',
      marginRight: 16,
    },
  }),
)

const useStylesOfLockIcon = makeStyles((theme: Theme) =>
  createStyles({
    root: {
      color: theme.palette.text.disabled,
      '&$checked': {
        color: '#E59500',
      },
    },
    checked: {},
  }),
)

type Props = {
  handleClose: React.MouseEventHandler<HTMLButtonElement>
}

const CreatePost: VFC<Props> = ({ handleClose }) => {
  const classes = useStyles()
  const classesOfLockIcon = useStylesOfLockIcon()

  const dispatch = useDispatch()
  const selector = useSelector((state: { users: Users }) => state)

  const userIcon = getIcon(selector)

  const [uploadedImageSrc, setUploadedImageSrc] = useState('')
  const [uploadedImage, setUploadedImage] = useState<File>()
  const [inputtedText, setInputtedText] = useState('')
  const [locked, setLocked] = useState(false)
  const [textCounter, setTextCounter] = useState(0)
  const [textCounterColor, setTextCounterColor] = useState('#86868b')
  const [disabled, setDisabled] = useState(true)

  const handleOnChangeFileInput = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { files } = e.target
    if (files && files.length > 0) {
      const imageUrl = window.URL.createObjectURL(files[0])
      setUploadedImageSrc(imageUrl)
      setUploadedImage(files[0])
      if (inputtedText.length < 141) {
        setDisabled(false)
      }
    }
  }

  const clearUploadedImg = () => {
    setUploadedImageSrc('')
    setUploadedImage(undefined)
    if (inputtedText.length === 0) {
      setDisabled(true)
    }
  }

  const handleOnchangeTextInput = (e: React.ChangeEvent<HTMLTextAreaElement>) => {
    const text = e.target.value
    const textLength = text.length
    setInputtedText(text)
    setTextCounter(textLength)
    if (textLength === 0 && uploadedImage) {
      setTextCounterColor('#86868b')
      setDisabled(false)
    } else if (textLength === 0 && !uploadedImage) {
      setTextCounterColor('#86868b')
      setDisabled(true)
    } else if (textLength > 0 && textLength < 141) {
      setTextCounterColor('#86868b')
      setDisabled(false)
    } else {
      setTextCounterColor('#e0245e')
      setDisabled(true)
    }
  }

  const handleOnChangeLockButton = () => {
    setLocked(!locked)
  }

  const handleOnClickToPost = (event: React.MouseEvent<HTMLButtonElement, MouseEvent>) => {
    dispatch(submitNewPost(inputtedText, locked, uploadedImage))
    handleClose(event)
  }

  return (
    <Box className={classes.container}>
      <Box className={classes.header}>
        <IconButton aria-label="close" className={classes.closeDisplayIconButton} onClick={handleClose}>
          <CloseIcon />
        </IconButton>
      </Box>
      <Box className={classes.main}>
        <Avatar alt="User icon" src={userIcon} sx={{ width: 48, height: 48, marginRight: 2 }} />
        <Box sx={{ width: '100%' }}>
          <TextareaAutosize
            minRows={3}
            maxRows={7}
            placeholder="投稿内容を入力。"
            style={{ width: '100%', marginBottom: 32 }}
            onChange={handleOnchangeTextInput}
          />
          {uploadedImageSrc && (
            <Box className={classes.displayUploadedImgContainer}>
              <IconButton
                aria-label="close"
                onClick={clearUploadedImg}
                sx={{ color: '#86868b', position: 'absolute', zIndex: 1, padding: 0.5 }}
              >
                <CancelIcon fontSize="large" />
              </IconButton>
              <DisplayUploadedImgModal uploadedImgSrc={uploadedImageSrc} />
            </Box>
          )}
          <Divider className={classes.divider} />
          <Box sx={{ display: 'flex', alignItems: 'center' }}>
            <label htmlFor="icon-button-file">
              <input
                className={classes.input}
                accept="image/*"
                id="icon-button-file"
                type="file"
                onChange={handleOnChangeFileInput}
              />
              <IconButton aria-label="upload picture" component="span">
                <AddPhotoAlternateIcon />
              </IconButton>
            </label>
            <Checkbox
              classes={classesOfLockIcon}
              icon={<LockOpenOutlinedIcon />}
              checkedIcon={<LockIcon />}
              onChange={handleOnChangeLockButton}
            />
            <span className={classes.textCounter} style={{ color: `${textCounterColor}` }}>
              {textCounter}/140
            </span>
            <Box sx={{ width: 112 }}>
              <ContainedRoundedCornerButton
                label="投稿する"
                onClick={handleOnClickToPost}
                disabled={disabled}
                backgroundColor="#2699fb"
              />
            </Box>
          </Box>
        </Box>
      </Box>
    </Box>
  )
}

export default CreatePost
