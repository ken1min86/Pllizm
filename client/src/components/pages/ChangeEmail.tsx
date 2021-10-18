import { ContainedRoundedCornerButton, ErrorMessages } from 'components/atoms';
import { HeaderWithBackAndTitle } from 'components/molecules';
import { DefaultTemplate } from 'components/templates';
import { useState, VFC } from 'react';
import { useDispatch } from 'react-redux';
import { EditEmail } from 'reducks/users/operations';

import { Box, TextField } from '@mui/material';

const ChangeEmail: VFC = () => {
  const dispatch = useDispatch()

  const [disabled, setDisabled] = useState(true)
  const [email, setEmail] = useState('')
  const [error, setError] = useState('')

  const handleChangeEmail = (e: React.ChangeEvent<HTMLTextAreaElement>) => {
    const text = e.target.value
    const textLength = text.length
    setEmail(text)
    if (textLength === 0) {
      setDisabled(true)
    } else {
      setDisabled(false)
    }
  }

  const handleClickToChangeEmail = () => {
    dispatch(EditEmail(email, setError))
  }

  const returnHeaderFunc = () => (
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

  return (
    <DefaultTemplate activeNavTitle="settings" returnHeaderFunc={returnHeaderFunc}>
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
        <ErrorMessages errors={[error]} />
      </Box>
    </DefaultTemplate>
  )
}

export default ChangeEmail
