import { goBack } from 'connected-react-router'
import { VFC } from 'react'
import { useDispatch } from 'react-redux'

import ArrowBackIcon from '@mui/icons-material/ArrowBack'
import { Box, Hidden } from '@mui/material'
import createStyles from '@mui/styles/createStyles'
import makeStyles from '@mui/styles/makeStyles'

import Logo from '../../../assets/HeaderLogo.png'

const useStyles = makeStyles((theme) =>
  createStyles({
    arrow: {
      color: theme.palette.info.main,
    },
    table: {
      backgroundColor: theme.palette.secondary.main,
    },
    title: {
      fontSize: '22px',
      color: theme.palette.primary.light,
      fontWeight: 'bold',
      marginLeft: '24px',
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
      <div>
        <Hidden smUp>
          <button type="button" onClick={back}>
            <ArrowBackIcon className={classes.arrow} />
          </button>
        </Hidden>
        <Hidden smDown>
          <img src={Logo} alt="ロゴ" />
        </Hidden>
      </div>
      <div>
        <div data-testid="header-title" className={classes.title}>
          {title}
        </div>
      </div>
    </Box>
  )
}

export default ReturnableHeaderTable
