import { VFC } from 'react';

import { Hidden, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

// eslint-disable-next-line import/no-useless-path-segments
import { AccountDrawer } from '../';
import Logo from '../../../assets/HeaderLogo.png';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    img: {
      width: 28,
      position: 'absolute',
      display: 'block',
      left: 'calc( 50% - 14px )',
    },
    title: {
      fontSize: 20,
      fontWeight: 'bold',
      marginLeft: 16,
      color: theme.palette.primary.light,
    },
  }),
)

type Props = {
  title: string
}

const HeaderWithTitleAndDrawer: VFC<Props> = ({ title }) => {
  const classes = useStyles()

  return (
    <>
      <Hidden smDown>
        <h1 className={classes.title}>{title}</h1>
      </Hidden>
      <Hidden smUp>
        <AccountDrawer />
        <img className={classes.img} src={Logo} alt="ロゴ" />
      </Hidden>
    </>
  )
}

export default HeaderWithTitleAndDrawer
