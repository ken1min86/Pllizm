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

const EndPasswordReset: VFC = () => {
  document.title = 'パスワード再設定完了 / Pllizm'

  const classes = useStyles()
  const dispatch = useDispatch()

  return (
    <>
      <HeaderWithLogo />
      <main className={classes.main}>
        <Box className={classes.container}>
          <Box mt={3} mb={3} className={classes.description}>
            パスワードの再設定が完了しました。
          </Box>
          <Box className={classes.buttonContainer}>
            <BlueSquareButton size="medium" label="ホームへ" onClick={() => dispatch(push('/home'))} />
          </Box>
        </Box>
      </main>
    </>
  )
}

export default EndPasswordReset
