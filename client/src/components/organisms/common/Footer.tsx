import { VFC } from 'react';

import TwitterIcon from '@mui/icons-material/Twitter';
import { Box, Link, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    footer: {
      paddingTop: '24px',
      paddingBottom: '24px',
      backgroundColor: theme.palette.secondary.main,
      paddingLeft: '24px',
      [theme.breakpoints.down('sm')]: {
        flexDirection: 'column',
        padding: 0,
        paddingTop: '21px',
        width: '100%',
      },
    },
    copyright: {
      fontSize: '11px',
      color: theme.palette.primary.main,
      marginRight: '56px',
      whiteSpace: 'nowrap',
      [theme.breakpoints.down('sm')]: {
        order: 3,
        marginBottom: '21px',
      },
    },
    link: {
      fontSize: '12px',
      color: theme.palette.primary.main,
      paddingLeft: '16px',
      paddingRight: '16px',
      lineHeight: '1',
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
      marginLeft: '20px',
      backgroundColor: theme.palette.primary.main,
      borderRadius: '50%',
      width: '30px',
      height: '30px',
      textAlign: 'center',
      verticalAlign: 'middle',
      fontSize: '18px',
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
        marginBottom: '21px',
      },
    },
    separatorWhenMobile: {
      [theme.breakpoints.down('sm')]: {
        width: '50%',
        textAlign: 'center',
        paddingTop: '16px',
        paddingBottom: '16px',
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
        marginBottom: '-1px',
      },
    },
    borderRightWhenMobile: {
      [theme.breakpoints.down('sm')]: {
        borderRight: '1px solid #4C524C',
      },
    },
    marginBotomWhenMobile: {
      [theme.breakpoints.down('sm')]: {
        marginBottom: '21px',
      },
    },
  }),
)
const Footer: VFC = () => {
  const classes = useStyles()

  return (
    <Box display="flex" alignItems="center" className={classes.footer}>
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
          お問い合わせ
        </li>
        <li
          className={`${classes.link} ${classes.separatorLine} ${classes.separatorWhenMobile} ${classes.borderTopWhenMobile} ${classes.borderBottomWhenMobile}`}
        >
          <Link href="/help/terms_of_use" underline="none">
            利用規約
          </Link>
        </li>
        <li
          className={`${classes.link} ${classes.separatorLine} ${classes.separatorWhenMobile} ${classes.borderTopWhenMobile} ${classes.borderRightWhenMobile} ${classes.borderBottomWhenMobile}`}
        >
          <Link href="/help/privacy_policy" underline="none">
            プライバシーポリシー
          </Link>
        </li>
        <li className={`${classes.link} ${classes.snsContainer}`}>
          <Link className={classes.snsIcon} href="https://twitter.com/plizm_jp">
            <TwitterIcon fontSize="small" />
          </Link>
        </li>
      </Box>
    </Box>
  )
}

export default Footer
