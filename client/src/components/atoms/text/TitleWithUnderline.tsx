import { VFC } from 'react';

import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

const useStyles = makeStyles(() =>
  createStyles({
    h1: {
      fontSize: 24,
      position: 'relative',
      '&::after': {
        position: 'absolute',
        content: '""',
        borderBottom: 'solid 1px #86868b',
        bottom: '-12px',
        width: '100%',
        display: 'block',
      },
    },
  }),
)

type Props = {
  title: string
}

const TitleWithUnderline: VFC<Props> = ({ title }) => {
  const classes = useStyles()

  return (
    <>
      <h1 className={classes.h1} data-testid="title">
        {title}
      </h1>
    </>
  )
}

export default TitleWithUnderline
