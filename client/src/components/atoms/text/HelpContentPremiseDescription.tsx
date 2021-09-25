import { VFC } from 'react'

import createStyles from '@mui/styles/createStyles'
import makeStyles from '@mui/styles/makeStyles'

const useStyles = makeStyles((theme) =>
  createStyles({
    p: {
      fontSize: '16px',
      marginLeft: '24px',
      [theme.breakpoints.down('sm')]: {
        fontSize: '12px',
        marginLeft: '8px',
      },
    },
  }),
)

const HelpContentPremiseDescription: VFC<{ description: string }> = ({ description }) => {
  const classes = useStyles()

  return <p className={classes.p}>{description}</p>
}

export default HelpContentPremiseDescription
