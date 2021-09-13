import { VFC } from 'react';

// お問い合わせ, 利用規約, プライバシーポリシー, TwitterのURLが確定し次第リンクを設定する
// import { useDispatch } from 'react-redux';
import { Box, Link } from '@material-ui/core';
import { createStyles, makeStyles } from '@material-ui/core/styles';
import TwitterIcon from '@material-ui/icons/Twitter';

const useStyles = makeStyles((theme) =>
  createStyles({
    footer: {
      paddingTop: '24px',
      paddingBottom: '24px',
      backgroundColor: theme.palette.secondary.main,
      paddingLeft: '24px',
      [theme.breakpoints.down('xs')]: {
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
      [theme.breakpoints.down('xs')]: {
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
      [theme.breakpoints.down('xs')]: {
        order: 2,
        padding: 0,
      },
    },

    separatorLine: {
      borderRight: '1px solid #4C524C',
      [theme.breakpoints.down('xs')]: {
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
      [theme.breakpoints.down('xs')]: {
        marginLeft: 0,
      },
    },
    snsContainer: {
      [theme.breakpoints.down('xs')]: {
        display: 'flex',
        justifyContent: 'center',
        order: 1,
        width: '100%',
        textAlign: 'center',
        marginBottom: '21px',
      },
    },
    separatorWhenMobile: {
      [theme.breakpoints.down('xs')]: {
        width: '50%',
        textAlign: 'center',
        paddingTop: '16px',
        paddingBottom: '16px',
      },
    },
    borderTopWhenMobile: {
      [theme.breakpoints.down('xs')]: {
        borderTop: '1px solid #4C524C',
      },
    },
    borderBottomWhenMobile: {
      [theme.breakpoints.down('xs')]: {
        borderBottom: '1px solid #4C524C',
        marginBottom: '-1px',
      },
    },
    borderRightWhenMobile: {
      [theme.breakpoints.down('xs')]: {
        borderRight: '1px solid #4C524C',
      },
    },
    marginBotomWhenMobile: {
      [theme.breakpoints.down('xs')]: {
        marginBottom: '21px',
      },
    },
  }),
);
const Footer: VFC = () => {
  const classes = useStyles();
  // お問い合わせ, 利用規約, プライバシーポリシー, TwitterのURLが確定し次第リンクを設定する
  // const dispatch = useDispatch();

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
          利用規約
        </li>
        <li
          className={`${classes.link} ${classes.separatorLine} ${classes.separatorWhenMobile} ${classes.borderTopWhenMobile} ${classes.borderRightWhenMobile} ${classes.borderBottomWhenMobile}`}
        >
          プライバシーポリシー
        </li>
        <li className={`${classes.link} ${classes.snsContainer}`}>
          <Link className={classes.snsIcon} href="https://twitter.com/plizm_jp">
            <TwitterIcon fontSize="small" />
          </Link>
        </li>
      </Box>
    </Box>
  );
};

export default Footer;
