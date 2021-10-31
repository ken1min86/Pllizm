import { VFC } from 'react';

import TwitterIcon from '@mui/icons-material/Twitter';
import { Box, Link, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    footer: {
      paddingTop: 24,
      paddingBottom: 24,
      backgroundColor: theme.palette.secondary.main,
      paddingLeft: 24,
      [theme.breakpoints.down('sm')]: {
        flexDirection: 'column',
        padding: 0,
        paddingTop: 21,
        width: '100%',
      },
    },
    copyright: {
      fontSize: 11,
      color: theme.palette.primary.main,
      marginRight: 56,
      whiteSpace: 'nowrap',
      [theme.breakpoints.down('sm')]: {
        order: 3,
        marginBottom: 21,
      },
    },
    link: {
      fontSize: 12,
      color: theme.palette.primary.main,
      paddingLeft: 16,
      paddingRight: 16,
      lineHeight: 1,
      textAlign: 'center',
      [theme.breakpoints.down('sm')]: {
        order: 2,
        padding: 0,
      },
    },

    separatorLine: {
      borderRight: '1px solid #4C524C',
      [theme.breakpoints.down('sm')]: {
        borderRight: 'none',
      },
    },
    snsIcon: {
      display: 'flex',
      justifyContent: 'center',
      alignItems: 'center',
      marginLeft: 20,
      backgroundColor: theme.palette.primary.main,
      borderRadius: '50%',
      width: 30,
      height: 30,
      textAlign: 'center',
      verticalAlign: 'middle',
      fontSize: 18,
      position: 'relative',
      color: theme.palette.secondary.main,
      [theme.breakpoints.down('sm')]: {
        marginLeft: 0,
      },
    },
    snsContainer: {
      [theme.breakpoints.down('sm')]: {
        display: 'flex',
        justifyContent: 'center',
        order: 1,
        width: '100%',
        textAlign: 'center',
        marginBottom: 21,
      },
    },
    separatorWhenMobile: {
      [theme.breakpoints.down('sm')]: {
        width: '50%',
        textAlign: 'center',
        paddingTop: 16,
        paddingBottom: 16,
      },
    },
    borderTopWhenMobile: {
      [theme.breakpoints.down('sm')]: {
        borderTop: '1px solid #4C524C',
      },
    },
    borderBottomWhenMobile: {
      [theme.breakpoints.down('sm')]: {
        borderBottom: '1px solid #4C524C',
        marginBottom: -1,
      },
    },
    borderRightWhenMobile: {
      [theme.breakpoints.down('sm')]: {
        borderRight: '1px solid #4C524C',
      },
    },
    marginBotomWhenMobile: {
      [theme.breakpoints.down('sm')]: {
        marginBottom: 21,
      },
    },
    ul: {
      display: 'inline',
    },
  }),
)
const Footer: VFC = () => {
  const classes = useStyles()

  return (
    <Box display="flex" alignItems="center" component="footer" className={classes.footer}>
      <small className={classes.copyright}>&copy; 2021 Plizm</small>
      <Box
        component="ul"
        display="flex"
        alignItems="center"
        flexWrap="wrap"
        width="100%"
        className={classes.marginBotomWhenMobile}
      >
        <li
          className={`${classes.link} ${classes.separatorLine} ${classes.separatorWhenMobile} ${classes.borderTopWhenMobile} ${classes.borderRightWhenMobile}`}
        >
          <a href="https://form.run/@pllizmjp">お問い合わせ</a>
        </li>
        <li
          className={`${classes.link} ${classes.separatorLine} ${classes.separatorWhenMobile} ${classes.borderTopWhenMobile} ${classes.borderBottomWhenMobile}`}
        >
          <Link href="/help/terms_of_use" underline="none" data-testid="terms-of-use-link">
            利用規約
          </Link>
        </li>
        <li
          className={`${classes.link} ${classes.separatorLine} ${classes.separatorWhenMobile} ${classes.borderTopWhenMobile} ${classes.borderRightWhenMobile} ${classes.borderBottomWhenMobile}`}
        >
          <Link href="/help/privacy_policy" underline="none" data-testid="privacy-policy-link">
            プライバシーポリシー
          </Link>
        </li>
        <li className={`${classes.link} ${classes.snsContainer}`}>
          <Link className={classes.snsIcon} href="https://twitter.com/pllizm_jp">
            <TwitterIcon fontSize="small" />
          </Link>
        </li>
      </Box>
    </Box>
  )
}

export default Footer
