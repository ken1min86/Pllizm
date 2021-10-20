import { VFC } from 'react';

import { Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    p: {
      color: theme.palette.warning.main,
      fontWeight: 'bold',
      fontSize: 14,
    },
  }),
)

type Props = {
  error: string
}

const ErrorMessage: VFC<Props> = ({ error }) => {
  const classes = useStyles()

  return <p className={classes.p}>{error}</p>
}

export default ErrorMessage
