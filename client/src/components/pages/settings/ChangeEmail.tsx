import { ContainedRoundedCornerButton, ErrorMessage } from 'components/atoms';
import { BottomNavigationBar, HeaderWithBackAndTitle } from 'components/molecules';
import { DefaultTemplate } from 'components/templates';
import { useState, VFC } from 'react';
import { useDispatch } from 'react-redux';
import { editEmail } from 'reducks/users/operations';

import { Box, Hidden, TextField } from '@mui/material';

const ChangeEmail: VFC = () => {
  const dispatch = useDispatch()

  const [disabled, setDisabled] = useState(true)
  const [email, setEmail] = useState('')
  const [error, setError] = useState('')

  const handleChangeEmail = (e: React.ChangeEvent<HTMLTextAreaElement>) => {
    const text = e.target.value.trim()
    const textLength = text.length
    setEmail(text)
    if (textLength === 0) {
      setDisabled(true)
    } else {
      setDisabled(false)
    }
  }

  const handleClickToChangeEmail = () => {
    dispatch(editEmail(email, setError))
  }

  const Header = (
    <Box sx={{ display: 'flex', alignItems: 'center', width: '100%' }}>
      <HeaderWithBackAndTitle title="メールアドレス変更" />
      <Box sx={{ marginLeft: 'auto', marginRight: 1, width: 104 }}>
        <ContainedRoundedCornerButton
          onClick={handleClickToChangeEmail}
          label="変更"
          backgroundColor="#2699fb"
          disabled={disabled}
        />
      </Box>
    </Box>
  )

  const Bottom = (
    <Hidden smUp>
      <BottomNavigationBar activeNav="settings" />
    </Hidden>
  )

  return (
    <DefaultTemplate activeNavTitle="settings" Header={Header} Bottom={Bottom}>
      <Box p={3}>
        <TextField
          label="メールアドレス"
          value={email}
          color="secondary"
          focused
          required
          fullWidth
          onChange={handleChangeEmail}
          sx={{ marginBottom: 1 }}
        />
        <ErrorMessage error={error} />
      </Box>
    </DefaultTemplate>
  )
}

export default ChangeEmail
