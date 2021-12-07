import { goBack } from 'connected-react-router';
import { VFC } from 'react';
import { useDispatch } from 'react-redux';

import ArrowBackIcon from '@mui/icons-material/ArrowBack';
import { Box, Hidden, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

import Logo from '../../../assets/img/HeaderLogo.png';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    arrow: {
      color: theme.palette.info.main,
    },
    logo: {
      marginRight: 8,
      width: 26.5,
    },
    table: {
      backgroundColor: theme.palette.secondary.main,
    },
    title: {
      fontSize: '22px',
      color: theme.palette.primary.light,
      fontWeight: 'bold',
    },
    button: {
      display: 'flex',
      alignItems: 'center',
      marginRight: 8,
    },
  }),
)

const ReturnableHeaderTable: VFC<{ title: string }> = ({ title }) => {
  const classes = useStyles()
  const dispatch = useDispatch()
  const back = () => {
    dispatch(goBack())
  }

  return (
    <Box className={classes.table} display="flex" alignItems="center" height="49px" paddingLeft="21px">
      <Hidden smUp>
        <button type="button" onClick={back} className={classes.button}>
          <ArrowBackIcon className={classes.arrow} />
        </button>
      </Hidden>
      <Hidden smDown>
        <img className={classes.logo} src={Logo} alt="ロゴ" />
      </Hidden>
      <div data-testid="header-title" className={classes.title}>
        {title}
      </div>
    </Box>
  )
}

export default ReturnableHeaderTable
