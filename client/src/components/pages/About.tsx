import { HeaderWithLogo } from 'components/molecules';
import { Footer, SigninModal, SignupModal } from 'components/organisms';
import { VFC } from 'react';

import { Box, Hidden, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

import BlindBirdLarge from '../../assets/img/BlindBirdLarge.svg';
import BlindBirdSmall from '../../assets/img/BlindBirdSmall.svg';
import BlueInkLarge from '../../assets/img/BlueInkLarge.jpg';
import BlueInkSmall from '../../assets/img/BlueInkSmall.jpg';
import CandleLarge from '../../assets/img/CandleLarge.jpg';
import CandleSmall from '../../assets/img/CandleSmall.jpg';
import ColorfulInkLarge from '../../assets/img/ColorfulInkLarge.jpg';
import ColorfulInkSmall from '../../assets/img/ColorfulInkSmall.jpg';
import HemisphereBubbleLarge from '../../assets/img/HemisphereBubbleLarge.jpg';
import HemisphereBubbleSmall from '../../assets/img/HemisphereBubbleSmall.jpg';
import PllizmFeatureDiagramLarge from '../../assets/img/PllizmFeatureDiagramLarge.svg';
import PllizmFeatureDiagramSmall from '../../assets/img/PllizmFeatureDiagramSmall.svg';
import PostExampleMobile from '../../assets/img/PostExampleMobile.svg';
import PostExamplePC1 from '../../assets/img/PostExamplePC1.svg';
import PostExamplePC2 from '../../assets/img/PostExamplePC2.svg';
import PostExamplePC3 from '../../assets/img/PostExamplePC3.svg';
import PrismLarge from '../../assets/img/PrismLarge.jpg';
import PrismSmall from '../../assets/img/PrismSmall.jpg';
import RefractedPostLarge from '../../assets/img/RefractedPostLarge.svg';
import RefractedPostSmall from '../../assets/img/RefractedPostSmall.svg';
import SkyLarge from '../../assets/img/SkyLarge.jpg';
import SkySmall from '../../assets/img/SkySmall.jpg';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    introContainer: {
      position: 'relative',
      background: 'center',
      backgroundSize: 'cover',
      width: '100%',
      [theme.breakpoints.down('sm')]: {
        backgroundImage: `url(${PrismSmall})`,
        height: 532,
      },
      [theme.breakpoints.up('sm')]: {
        backgroundImage: `url(${PrismLarge})`,
        height: 751,
      },
    },
    introWrapper: {
      display: 'flex',
      flexDirection: 'column',
      position: 'absolute',
      [theme.breakpoints.down('sm')]: {
        top: 160,
        right: '10vw',
      },
      [theme.breakpoints.up('sm')]: {
        top: 245,
        left: '10vw',
      },
    },
    introMessage: {
      color: theme.palette.primary.light,
      [theme.breakpoints.down('sm')]: {
        fontSize: 22,
      },
      [theme.breakpoints.up('sm')]: {
        fontSize: 32,
      },
    },
    demoPostsContainer: {
      background: 'center',
      backgroundSize: 'cover',
      width: '100%',
      display: 'flex',
      [theme.breakpoints.down('sm')]: {
        backgroundImage: `url(${ColorfulInkSmall})`,
        height: 514,
        justifyContent: 'space-around',
        padding: '64px 32px',
      },
      [theme.breakpoints.up('sm')]: {
        backgroundImage: `url(${ColorfulInkLarge})`,
        height: 554,
        paddingLeft: '5vw',
        paddingRight: '5vw',
        alignItems: 'center',
        justifyContent: 'space-around',
        gap: 4,
        flexWrap: 'wrap',
      },
    },
    notTwitterContainer: {
      background: 'center',
      backgroundSize: 'cover',
      width: '100%',
      display: 'flex',
      alignItems: 'flex-start',
      [theme.breakpoints.down('sm')]: {
        backgroundImage: `url(${SkySmall})`,
        height: 300,
        padding: '64px 32px 0 32px',
      },
      [theme.breakpoints.up('sm')]: {
        backgroundImage: `url(${SkyLarge})`,
        height: 665,
        padding: '156px 64px 0 64px',
      },
    },
    blindBird: {
      height: 'auto',
      [theme.breakpoints.down('sm')]: {
        width: 132,
        marginRight: 8,
      },
      [theme.breakpoints.up('sm')]: {
        width: 277,
        marginRight: 123,
      },
    },
    notTwitterTextContainer: {
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'flex-start',
      [theme.breakpoints.down('sm')]: {
        marginTop: -8,
      },
      [theme.breakpoints.up('sm')]: {
        marginTop: -40,
      },
    },
    notTwitterTitle: {
      fontWeight: 'bold',
      [theme.breakpoints.down('sm')]: {
        fontSize: 22,
        marginBottom: 8,
      },
      [theme.breakpoints.up('sm')]: {
        color: theme.palette.primary.light,
        marginBottom: 24,
        fontSize: 80,
      },
    },
    notTwitterDescription: {
      [theme.breakpoints.down('sm')]: {
        fontSize: 11,
      },
      [theme.breakpoints.up('sm')]: {
        fontSize: 20,
      },
    },
    refractedPostContainer: {
      background: 'center',
      backgroundSize: 'cover',
      width: '100%',
      [theme.breakpoints.down('sm')]: {
        backgroundImage: `url(${CandleSmall})`,
        height: 274,
        display: 'flex',
        justifyContent: 'space-evenly',
        alignItems: 'center',
      },
      [theme.breakpoints.up('sm')]: {
        position: 'relative',
        backgroundImage: `url(${CandleLarge})`,
        height: 615,
      },
    },
    refractedPost: {
      [theme.breakpoints.down('sm')]: {
        width: 321,
        height: 'auto',
      },
      [theme.breakpoints.up('sm')]: {
        position: 'absolute',
        top: 162,
        right: '15vw',
      },
    },
    refractContainer: {
      background: 'center',
      backgroundSize: 'cover',
      width: '100%',
      [theme.breakpoints.down('sm')]: {
        backgroundImage: `url(${BlueInkSmall})`,
        height: 411,
        padding: '64px 32px',
      },
      [theme.breakpoints.up('sm')]: {
        position: 'relative',
        backgroundImage: `url(${BlueInkLarge})`,
        height: 703,
        padding: 88,
        display: 'flex',
        justifyContent: 'space-between',
      },
    },
    refractTextContainer: {
      display: 'flex',
      flexDirection: 'column',
      [theme.breakpoints.down('sm')]: {
        maxWidth: 193,
        marginBottom: 24,
      },
      [theme.breakpoints.up('sm')]: {
        maxWidth: 428,
      },
    },
    refractTitle: {
      color: theme.palette.primary.light,
      fontWeight: 'bold',
      marginBottom: 32,
      [theme.breakpoints.down('sm')]: {
        fontSize: 24,
      },
      [theme.breakpoints.up('sm')]: {
        fontSize: 80,
        alignSelf: 'flex-start',
      },
    },
    refractDescription: {
      color: theme.palette.primary.light,
      [theme.breakpoints.down('sm')]: {
        fontSize: 11,
      },
      [theme.breakpoints.up('sm')]: {
        fontSize: 20,
      },
    },
    pllizmFeatureDiagram: {
      [theme.breakpoints.down('sm')]: {
        display: 'block',
        marginLeft: 'auto',
      },
      [theme.breakpoints.up('sm')]: {
        alignSelf: 'flex-end',
      },
    },
    beginPllizmContainer: {
      position: 'relative',
      background: 'center',
      backgroundSize: 'cover',
      width: '100%',
      [theme.breakpoints.down('sm')]: {
        backgroundImage: `url(${HemisphereBubbleSmall})`,
        height: 283,
      },
      [theme.breakpoints.up('sm')]: {
        backgroundImage: `url(${HemisphereBubbleLarge})`,
        height: 687,
      },
    },
    beginPllizmContentsContainer: {
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      position: 'absolute',
      left: 0,
      right: 0,
      margin: 'auto',
      [theme.breakpoints.down('sm')]: {
        top: 64,
        width: 290,
      },
      [theme.breakpoints.up('sm')]: {
        top: 194,
        width: 290,
      },
    },
    beginPllizmTitle: {
      color: theme.palette.primary.light,
      fontWeight: 'bold',
      [theme.breakpoints.down('sm')]: {
        fontSize: 22,
        marginBottom: 24,
      },
      [theme.breakpoints.up('sm')]: {
        fontSize: 40,
        marginBottom: 16,
      },
    },
    signup: {
      width: 'min(318px, 90vw)',
      marginBottom: 16,
    },
    signin: {
      width: 'min(318px, 90vw)',
    },
  }),
)

const About: VFC = () => {
  const classes = useStyles()

  return (
    <>
      <HeaderWithLogo />
      <main>
        <Box className={classes.introContainer}>
          <Box className={classes.introWrapper}>
            <Hidden smDown>
              <span className={classes.introMessage}>Pllizmはあなたにもうひとつの</span>
              <span className={classes.introMessage}>世界を提供します。</span>
              <Box component="span" sx={{ height: 2 }} />
              <span className={classes.introMessage}>この世界ではあなたは自由です。</span>
            </Hidden>
            <Hidden smUp>
              <span className={classes.introMessage}>Pllizmはあなたに</span>
              <span className={classes.introMessage}>もうひとつの世界を</span>
              <span className={classes.introMessage}>提供します。</span>
              <Box component="span" sx={{ height: 2 }} />
              <span className={classes.introMessage}>この世界では</span>
              <span className={classes.introMessage}>あなたは自由です。</span>
            </Hidden>
          </Box>
        </Box>
        <Box className={classes.demoPostsContainer}>
          <Hidden smDown>
            <img src={PostExamplePC1} alt="Post example PC 1" />
            <img src={PostExamplePC2} alt="Post example PC 2" />
            <img src={PostExamplePC3} alt="Post example PC 3" />
          </Hidden>
          <Hidden smUp>
            <img src={PostExampleMobile} alt="Post example mobile" />
          </Hidden>
        </Box>
        <Box className={classes.notTwitterContainer}>
          <Hidden smDown>
            <img className={classes.blindBird} alt="Large Blind Bird" src={BlindBirdLarge} />
          </Hidden>
          <Hidden smUp>
            <img className={classes.blindBird} alt="Small Blind Bird" src={BlindBirdSmall} />
          </Hidden>
          <Box className={classes.notTwitterTextContainer}>
            <span className={classes.notTwitterTitle}>Twitter?</span>
            <span className={classes.notTwitterDescription}>違います。</span>
            <Box component="span" sx={{ height: 2 }} />
            <span className={classes.notTwitterDescription}>
              Pllizmはあなたと、あなたの知り合いで利用するサービスです。
            </span>
            <Box component="span" sx={{ height: 2 }} />
            <span className={classes.notTwitterDescription}>
              ただし、あなたは自分以外のつぶやきが、知り合いの誰によって投稿されたのか分かりません。
            </span>
            <Box component="span" sx={{ height: 2 }} />
            <span className={classes.notTwitterDescription}>たった1つの例外を除いて。</span>
          </Box>
        </Box>
        <Box className={classes.refractedPostContainer}>
          <Hidden smUp>
            <img className={classes.refractedPost} src={RefractedPostSmall} alt="Refracted Post Mobile" />
          </Hidden>
          <Hidden smDown>
            <img className={classes.refractedPost} src={RefractedPostLarge} alt="Refracted Post PC" />
          </Hidden>
        </Box>
        <Box className={classes.refractContainer}>
          <Box className={classes.refractTextContainer}>
            <span className={classes.refractTitle}>refract</span>
            <span className={classes.refractDescription}>週に一度、あなたの知り合いの投稿を非匿名化できます。</span>
            <Box component="span" sx={{ height: 2 }} />
            <span className={classes.refractDescription}>これをrefractと呼びます。</span>
            <Box component="span" sx={{ height: 2 }} />
            <span className={classes.refractDescription}>refractできる投稿は一週間に1つのみです。</span>
            <Box component="span" sx={{ height: 2 }} />
            <span className={classes.refractDescription}>
              また、投稿をロックすることでrefractされないようにすることもできます。
            </span>
          </Box>
          <Hidden smUp>
            <img
              className={classes.pllizmFeatureDiagram}
              src={PllizmFeatureDiagramSmall}
              alt="Pllizm feature diagram Mobile"
            />
          </Hidden>
          <Hidden smDown>
            <img
              className={classes.pllizmFeatureDiagram}
              src={PllizmFeatureDiagramLarge}
              alt="Pllizm feature diagram PC"
            />
          </Hidden>
        </Box>
        <Box className={classes.beginPllizmContainer}>
          <Box className={classes.beginPllizmContentsContainer}>
            <span className={classes.beginPllizmTitle}>Pllizmを始める</span>
            <Box className={classes.signup}>
              <SignupModal type="button" />
            </Box>
            <Box className={classes.signin}>
              <SigninModal type="button" />
            </Box>
          </Box>
        </Box>
      </main>
      <Footer />
    </>
  )
}

export default About
