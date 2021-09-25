import { VFC } from 'react'

import createStyles from '@mui/styles/createStyles'
import makeStyles from '@mui/styles/makeStyles'

const useStyles = makeStyles(() =>
  createStyles({
    h2: {
      fontSize: '22px',
      marginBottom: '8px',
    },
  }),
)

const HelpContentItemTitle: VFC<{ itemTitle: string }> = ({ itemTitle }) => {
  const classes = useStyles()

  return <h2 className={classes.h2}>{itemTitle}</h2>
}

export default HelpContentItemTitle
