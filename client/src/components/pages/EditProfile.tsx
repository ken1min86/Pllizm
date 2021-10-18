import { ContainedRoundedCornerButton } from 'components/atoms';
import { HeaderWithBackAndTitle } from 'components/molecules';
import { DefaultTemplate } from 'components/templates';
import useUserProfiles from 'hooks/useUserProfiles';
import { useEffect, useState, VFC } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { ChangeProfile } from 'reducks/users/operations';
import { Users } from 'util/types/redux/users';

import AddAPhotoIcon from '@mui/icons-material/AddAPhoto';
import { Avatar, Box, IconButton, TextField, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

import { getUserId } from '../../reducks/users/selectors';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    icon: {
      [theme.breakpoints.down('sm')]: {
        width: 88,
        height: 88,
      },
      [theme.breakpoints.up('sm')]: {
        width: 112,
        height: 112,
      },
    },
    hiddenInput: {
      display: 'none',
    },
  }),
)

const EditProfile: VFC = () => {
  const classes = useStyles()
  const dispatch = useDispatch()

  const [uploadedUserIcon, setUploadedUserIcon] = useState<File>()
  const [userIconUrl, setUserIconUrl] = useState<string>()
  const [userName, setUserName] = useState<string>('')
  const [bio, setBio] = useState<string>()
  const [disabled, setDisabled] = useState(false)
  const [textLengthOfUserName, setTextLengthOfUserName] = useState(0)
  const [textLengthOfBio, setTextLengthOfBio] = useState(0)

  const selector = useSelector((state: { users: Users }) => state)
  const userId = getUserId(selector)

  const { getUserProfile, userProfile } = useUserProfiles(userId)

  useEffect(() => {
    getUserProfile()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  useEffect(() => {
    if (userProfile) {
      setUserIconUrl(userProfile.icon_url)
      setUserName(userProfile.user_name)
      setBio(userProfile.bio)
      setTextLengthOfUserName(userProfile.user_name.length)
      setTextLengthOfBio(userProfile.bio ? userProfile.bio.length : 0)
    }
  }, [userProfile])

  const handleOnChangeFileInput = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { files } = e.target
    if (files && files.length > 0) {
      const imageUrl = window.URL.createObjectURL(files[0])
      setUserIconUrl(imageUrl)
      setUploadedUserIcon(files[0])
    }
  }

  const handleChangeUserName = (e: React.ChangeEvent<HTMLTextAreaElement>) => {
    const text = e.target.value
    const textLength = text.length
    if (textLength === 0) {
      setUserName(text)
      setDisabled(true)
      setTextLengthOfUserName(textLength)
    } else if (textLength > 0 && textLength <= 50) {
      setUserName(text)
      setDisabled(false)
      setTextLengthOfUserName(textLength)
    }
  }

  const handleChangeBio = (e: React.ChangeEvent<HTMLTextAreaElement>) => {
    const text = e.target.value
    const textLength = text.length
    if (textLength <= 160) {
      setBio(e.target.value)
      setTextLengthOfBio(textLength)
    }
  }

  const handleClickToEdit = () => {
    dispatch(ChangeProfile(userName, bio, uploadedUserIcon))
  }

  const returnHeaderFunc = () => (
    <Box sx={{ display: 'flex', alignItems: 'center', width: '100%' }}>
      <HeaderWithBackAndTitle title="変更" />
      <Box sx={{ marginLeft: 'auto', marginRight: 1, width: 104 }}>
        <ContainedRoundedCornerButton
          onClick={handleClickToEdit}
          label="保存"
          backgroundColor="#2699fb"
          disabled={disabled}
        />
      </Box>
    </Box>
  )

  return (
    <DefaultTemplate activeNavTitle="none" returnHeaderFunc={returnHeaderFunc}>
      <Box p={3} sx={{ width: '100%', position: 'relative' }}>
        <Box sx={{ height: 136 }}>
          <Box sx={{ position: 'absolute' }} mb={3}>
            <Avatar alt="User icon" src={userIconUrl} className={classes.icon} />
          </Box>
          <Box sx={{ position: 'absolute' }} mb={3}>
            <label htmlFor="icon-button-file">
              <input
                className={classes.hiddenInput}
                accept="image/*"
                id="icon-button-file"
                type="file"
                onChange={handleOnChangeFileInput}
              />
              <IconButton aria-label="upload picture" component="span" className={classes.icon}>
                <AddAPhotoIcon sx={{ fontSize: 27 }} />
              </IconButton>
            </label>
          </Box>
        </Box>
        <TextField
          label={`名前 ${textLengthOfUserName}/50`}
          value={userName}
          color="secondary"
          focused
          required
          fullWidth
          sx={{ marginBottom: 3 }}
          onChange={handleChangeUserName}
        />
        <TextField
          label={`自己紹介 ${textLengthOfBio}/160`}
          value={bio}
          color="secondary"
          focused
          multiline
          fullWidth
          sx={{ marginBottom: 3 }}
          onChange={handleChangeBio}
        />
      </Box>
    </DefaultTemplate>
  )
}

export default EditProfile
