import { VFC } from 'react'

import { Theme } from '@mui/material'
import createStyles from '@mui/styles/createStyles'
import makeStyles from '@mui/styles/makeStyles'

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    h1: {
      fontSize: '30px',
      marginBottom: '8px',
      [theme.breakpoints.down('sm')]: {
        fontSize: '24px',
        marginBottom: '8px',
      },
    },
  }),
)

const HelpContentTitle: VFC<{ title: string }> = ({ title }) => {
  const classes = useStyles()

  return (
    <h1 className={classes.h1} data-testid="terms-of-use-header">
      {title}
    </h1>
  )
}

export default HelpContentTitle
