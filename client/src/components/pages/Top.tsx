import { ContainedWhiteRoundedCornerButton } from 'components/atoms';
import { HeaderWithLogo } from 'components/molecules';
import { Footer, SigninModal, SignupModal } from 'components/organisms';
import { push } from 'connected-react-router';
import { VFC } from 'react';
import { useDispatch } from 'react-redux';

import { Box, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

import TopLarge from '../../assets/TopLarge.jpg';
import TopSmall from '../../assets/TopSmall.jpg';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    main: {
      [theme.breakpoints.down('sm')]: {
        backgroundImage: `url(${TopSmall})`,
        background: 'center',
        backgroundSize: 'cover',
        width: '100%',
        height: 546,
        minHeight: 'calc( 100vh - 49px - 222px )',
      },
      [theme.breakpoints.up('sm')]: {
        backgroundImage: `url(${TopLarge})`,
        background: 'center',
        backgroundSize: 'cover',
        width: '100%',
        height: 687,
        minHeight: 'calc( 100vh - 49px - 78px )',
      },
    },
    h1: {
      color: theme.palette.primary.light,
      fontWeight: 'bold',
      marginBottom: 14,
      position: 'absolute',
      [theme.breakpoints.down('sm')]: {
        fontSize: 24,
        top: 90,
        left: 122,
      },
      [theme.breakpoints.up('sm')]: {
        fontSize: 30,
        top: 193,
      },
    },
    detail: {
      position: 'absolute',
      [theme.breakpoints.down('sm')]: {
        top: 139,
        left: 122,
      },
      [theme.breakpoints.up('sm')]: {
        top: 261,
      },
    },
    signup: {
      position: 'absolute',
      [theme.breakpoints.down('sm')]: {
        bottom: 133,
        left: 122,
      },
      [theme.breakpoints.up('sm')]: {
        bottom: 120,
      },
    },
    signin: {
      position: 'absolute',
      [theme.breakpoints.down('sm')]: {
        bottom: 84,
        left: 122,
      },
      [theme.breakpoints.up('sm')]: {
        bottom: 64,
      },
    },
  }),
)

const Top: VFC = () => {
  const classes = useStyles()
  const dispatch = useDispatch()
  const onClickHandler = () => {
    dispatch(push('/about'))
  }

  return (
    <>
      <HeaderWithLogo />
      <main className={classes.main}>
        <Box sx={{ display: 'flex', justifyContent: 'center', width: '100%', height: '100%', position: 'relative' }}>
          <h1 className={classes.h1} data-testid="header-title">
            こっちも現実。
          </h1>
          <Box sx={{ width: 217 }} className={classes.detail}>
            <ContainedWhiteRoundedCornerButton label="更に詳しく" onClick={onClickHandler} />
          </Box>
          <Box className={classes.signup}>
            <SignupModal type="button" />
          </Box>
          <Box className={classes.signin}>
            <SigninModal type="button" />
          </Box>
        </Box>
      </main>
      <Footer />
    </>
  )
}

export default Top
