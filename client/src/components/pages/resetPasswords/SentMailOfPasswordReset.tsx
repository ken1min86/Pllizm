import { BlueSquareButton } from 'components/atoms';
import { HeaderWithLogo } from 'components/molecules';
import { push } from 'connected-react-router';
import { VFC } from 'react';
import { useDispatch } from 'react-redux';

import { Box, Theme } from '@mui/material';
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
      width: 200,
    },
  }),
)
const SentMailOfPasswordReset: VFC = () => {
  document.title = 'パスワード再設定 / Pllizm'

  const classes = useStyles()
  const dispatch = useDispatch()

  return (
    <>
      <HeaderWithLogo />
      <main className={classes.main}>
        <Box className={classes.container}>
          <Box mt={3} mb={3} className={classes.description}>
            再発行リクエストを受け付けました。
            <br />
            送信頂いたメールアドレスでアカウントの登録が確認できた場合はパスワード再発行メールが送信されます。
            <br />
            メールの指示に従ってパスワードの再設定を行って下さい。
          </Box>
          <Box className={classes.buttonContainer}>
            <BlueSquareButton size="medium" label="トップページに戻る" onClick={() => dispatch(push('/'))} />
          </Box>
        </Box>
      </main>
    </>
  )
}

export default SentMailOfPasswordReset
