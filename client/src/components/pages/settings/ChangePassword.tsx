import { ContainedRoundedCornerButton, ErrorMessage } from 'components/atoms';
import { HeaderWithBackAndTitle } from 'components/molecules';
import { DefaultTemplate } from 'components/templates';
import { useState, VFC } from 'react';
import { useDispatch } from 'react-redux';
import { editPassword } from 'reducks/users/operations';

import { Box, TextField, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

const useStylesOfTextField = makeStyles((theme: Theme) =>
  createStyles({
    root: {
      '& .css-vjgevm-MuiFormHelperText-root': {
        color: theme.palette.text.primary,
      },
    },
  }),
)

const ChangePassword: VFC = () => {
  const classesOfTextField = useStylesOfTextField()
  const dispatch = useDispatch()

  const [password, setPassword] = useState('')
  const [passwordConfirmation, setPasswordConfirmation] = useState('')
  const [error, setError] = useState('')

  const handleChangePassword = (e: React.ChangeEvent<HTMLTextAreaElement>) => {
    setPassword(e.target.value)
  }

  const handleChangePasswordConfirmation = (e: React.ChangeEvent<HTMLTextAreaElement>) => {
    setPasswordConfirmation(e.target.value)
  }

  const handleClickToChangePassword = () => {
    dispatch(editPassword(password, passwordConfirmation, setError))
  }

  const Header = (
    <Box sx={{ display: 'flex', alignItems: 'center', width: '100%' }}>
      <HeaderWithBackAndTitle title="パスワード変更" />
      <Box sx={{ marginLeft: 'auto', marginRight: 1, width: 104 }}>
        <ContainedRoundedCornerButton
          onClick={handleClickToChangePassword}
          label="変更"
          backgroundColor="#2699fb"
          disabled={false}
        />
      </Box>
    </Box>
  )

  return (
    <DefaultTemplate activeNavTitle="settings" Header={Header}>
      <Box p={3}>
        <TextField
          label="パスワード"
          value={password}
          color="secondary"
          type="password"
          focused
          required
          fullWidth
          onChange={handleChangePassword}
          sx={{ marginBottom: 2 }}
          helperText="8文字以上で設定してください"
          classes={classesOfTextField}
        />
        <TextField
          label="パスワード(確認)"
          value={passwordConfirmation}
          color="secondary"
          type="password"
          focused
          required
          fullWidth
          onChange={handleChangePasswordConfirmation}
          sx={{ marginBottom: 1.5 }}
        />
        <ErrorMessage error={error} />
      </Box>
    </DefaultTemplate>
  )
}

export default ChangePassword
