import { push } from 'connected-react-router';
import { VFC } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { getIcon } from 'reducks/users/selectors';
import { Users } from 'util/types/redux/users';

import HomeRoundedIcon from '@mui/icons-material/HomeRounded';
import { Box, IconButton, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

// eslint-disable-next-line import/no-useless-path-segments
import { IconWithTextLink } from '../';
import Logo from '../../../assets/img/HeaderLogo.png';
import { LogoLink } from '../../atoms';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    header: {
      position: 'fixed',
      backgroundColor: theme.palette.secondary.main,
      height: 49,
      display: 'flex',
      alignItems: 'center',
      [theme.breakpoints.up('sm')]: {
        order: 2,
        minWidth: 500,
      },
      [theme.breakpoints.down('sm')]: {
        width: '100%',
      },
    },
    img: {
      display: 'block',
      width: 28,
      marginLeft: 'auto',
      marginRight: 'auto',
    },
    icon: {
      position: 'relative',
      marginLeft: 8,
      width: 28,
      borderRadius: '50%',
    },
    button: {
      position: 'absolute',
    },
    nav: {
      order: 1,
      display: 'flex',
      flexDirection: 'column',
      marginLeft: 'auto',
      marginRight: 40,
      backgroundColor: theme.palette.primary.main,
    },
  }),
)

type Props = {
  onClick: (event: React.MouseEvent<HTMLButtonElement>) => void
}

const HeaderInHome: VFC<Props> = ({ onClick }) => {
  const classes = useStyles()
  const dispatch = useDispatch()
  const selector = useSelector((state: { users: Users }) => state)
  const icon = getIcon(selector)
  const onClickHandler = () => {
    dispatch(push('/home'))
  }

  return (
    <Box sx={{ display: 'flex' }}>
      <header className={classes.header}>
        <IconButton aria-label="open banner" className={classes.button} onClick={onClick}>
          <img src={icon} alt="アイコン" className={classes.icon} />
        </IconButton>
        <img className={classes.img} src={Logo} alt="ロゴ" />
      </header>
      <nav className={classes.nav}>
        <LogoLink width={30} onClick={onClickHandler} />
        <IconWithTextLink title="ホーム" path="/home" isActive>
          <HomeRoundedIcon />
        </IconWithTextLink>
      </nav>
      <footer />
    </Box>
  )
}
export default HeaderInHome
