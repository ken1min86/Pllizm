import { VFC } from 'react';

import { Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

import Logo from '../../../assets/img/HeaderLogo.png';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    header: {
      backgroundColor: theme.palette.secondary.main,
      height: 49,
      display: 'flex',
      alignItems: 'center',
      paddingLeft: 16,
    },
    img: {
      marginRight: 8,
      width: 26.5,
    },
    span: {
      fontSize: 21,
      fontWeight: 'bold',
      color: theme.palette.primary.light,
    },
  }),
)

const HeaderWithLogo: VFC = () => {
  const classes = useStyles()

  return (
    <header className={classes.header}>
      <img className={classes.img} src={Logo} alt="ロゴ" />
      <span className={classes.span}>Plizm</span>
    </header>
  )
}
export default HeaderWithLogo
