import { ContainedRoundedCornerButton, ErrorMessages, TitleWithUnderline } from 'components/atoms';
import { HeaderWithLogo } from 'components/molecules';
import { useCallback, useState, VFC } from 'react';
import { useDispatch } from 'react-redux';
import { sendMailOfPasswordReset } from 'reducks/users/operations';

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
  }),
)

const BeginPasswordReset: VFC = () => {
  const classes = useStyles()
  const dispatch = useDispatch()

  const [email, setEmail] = useState('')
  const [error, setError] = useState('')

  const inputEmail = useCallback(
    (event) => {
      // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
      setEmail(event.target.value)
    },
    [setEmail],
  )

  return (
    <>
      <HeaderWithLogo />
      <main className={classes.main}>
        <Box className={classes.container}>
          <Box mt={2} mb={4}>
            <TitleWithUnderline title="パスワードをリセットする" />
          </Box>
          <Box mb={3} className={classes.description}>
            Plizmに登録したメールアドレスを入力して下さい。
            <br />
            パスワードを設定するためのURLをお送りします。
          </Box>
          <Box mb={1}>
            <TextField label="登録したメールアドレス" color="secondary" fullWidth focused onChange={inputEmail} />
          </Box>
          <Box mb={1}>
            <ErrorMessages errors={[error]} />
          </Box>
          <Box className={classes.buttonContainer}>
            <ContainedRoundedCornerButton
              label="送信"
              onClick={() => {
                dispatch(sendMailOfPasswordReset(email, setError))
              }}
              backgroundColor="#2699fb"
            />
          </Box>
        </Box>
      </main>
    </>
  )
}

export default BeginPasswordReset
