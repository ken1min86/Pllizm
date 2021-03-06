import { ContainedRoundedCornerButton, ErrorMessage, TitleWithUnderline } from 'components/atoms';
import { HeaderWithLogo } from 'components/molecules';
import { useCallback, useState, VFC } from 'react';
import { useDispatch } from 'react-redux';
import { useLocation } from 'react-router';
import { resetPassword } from 'reducks/users/operations';

import { Box, TextField, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    main: {
      backgroundColor: theme.palette.primary.main,
      height: '100%',
      display: 'flex',
      justifyContent: 'center',
    },
    container: {
      paddingLeft: 16,
      paddingRight: 16,
      maxWidth: 600,
      width: '100%',
    },
    description: {
      fontSize: 14,
    },
    buttonContainer: {
      width: 68,
    },
    span: {
      display: 'block',
      fontSize: 12,
      marginTop: 4,
      marginBottom: 16,
    },
  }),
)

const PasswordReset: VFC = () => {
  document.title = 'パスワード再設定 / Pllizm'

  const classes = useStyles()
  const dispatch = useDispatch()

  const [password, setPassword] = useState('')
  const [passwordConfirmation, setPasswordConfirmation] = useState('')
  const [error, setError] = useState('')

  const inputPassword = useCallback(
    (event: React.ChangeEvent<HTMLTextAreaElement>) => {
      setPassword(event.target.value.trim())
    },
    [setPassword],
  )

  const inputPasswordConfirmation = useCallback(
    (event: React.ChangeEvent<HTMLTextAreaElement>) => {
      setPasswordConfirmation(event.target.value.trim())
    },
    [setPasswordConfirmation],
  )

  const { search } = useLocation()
  const query = new URLSearchParams(search)
  const accessToken = query.get('access-token')
  const client = query.get('client')
  const uid = query.get('uid')

  return (
    <>
      <HeaderWithLogo />
      <main className={classes.main}>
        <Box className={classes.container}>
          <Box mt={2} mb={4}>
            <TitleWithUnderline title="パスワードを再設定する" />
          </Box>
          <Box mb={3} className={classes.description}>
            新しいパスワードを入力して、パスワードを再設定してください。
          </Box>
          <Box mb={1}>
            <TextField
              id="outlined-password-input"
              label="パスワード"
              type="password"
              autoComplete="password"
              variant="outlined"
              value={password}
              onChange={inputPassword}
              focused
              color="secondary"
              fullWidth
            />
            <span className={classes.span}>8文字以上で設定してください</span>
          </Box>
          <Box mb={1} width="100%">
            <TextField
              id="outlined-password-input"
              label="パスワード(確認)"
              type="password"
              autoComplete="password"
              variant="outlined"
              value={passwordConfirmation}
              onChange={inputPasswordConfirmation}
              focused
              color="secondary"
              fullWidth
            />
          </Box>
          <Box mb={1}>
            <ErrorMessage error={error} />
          </Box>
          <Box className={classes.buttonContainer}>
            <ContainedRoundedCornerButton
              label="送信"
              onClick={() => {
                dispatch(resetPassword(password, passwordConfirmation, accessToken, client, uid, setError))
              }}
              backgroundColor="#2699fb"
            />
          </Box>
        </Box>
      </main>
    </>
  )
}

export default PasswordReset
