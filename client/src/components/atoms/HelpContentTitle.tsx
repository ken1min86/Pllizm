import { VFC } from 'react';

import { createStyles, makeStyles } from '@material-ui/core/styles';

const useStyles = makeStyles((theme) =>
  createStyles({
    h1: {
      fontSize: '30px',
      marginBottom: '8px',
      [theme.breakpoints.down('xs')]: {
        fontSize: '24px',
        marginBottom: '8px',
      },
    },
  }),
);

const HelpContentTitle: VFC<{ title: string }> = ({ title }) => {
  const classes = useStyles();

  return (
    <h1 className={classes.h1} data-testid="terms-of-use-header">
      {title}
    </h1>
  );
};

export default HelpContentTitle;
