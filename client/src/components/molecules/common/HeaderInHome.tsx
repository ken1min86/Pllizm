import { VFC } from 'react';

import { IconButton, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

import Logo from '../../../assets/HeaderLogo.png';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    header: {
      backgroundColor: theme.palette.secondary.main,
      height: 49,
      display: 'flex',
      alignItems: 'center',
      paddingLeft: 16,
    },
    span: {
      fontSize: 21,
      fontWeight: 'bold',
      color: theme.palette.primary.light,
    },
    img: {
      display: 'block',
      width: 28,
    },
  }),
)

const HeaderInHome: VFC = () => {
  const classes = useStyles()

  return (
    <header className={classes.header}>
      <IconButton aria-label="delete">{/* <DeleteIcon /> */}</IconButton>
      <img className={classes.img} src={Logo} alt="ロゴ" />
    </header>
  )
}
export default HeaderInHome
