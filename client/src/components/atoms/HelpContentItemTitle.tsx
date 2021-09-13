import { VFC } from 'react';

import { createStyles, makeStyles } from '@material-ui/core/styles';

const useStyles = makeStyles(() =>
  createStyles({
    h2: {
      fontSize: '22px',
      marginBottom: '8px',
    },
  }),
);

const HelpContentItemTitle: VFC<{ itemTitle: string }> = ({ itemTitle }) => {
  const classes = useStyles();

  return <h2 className={classes.h2}>{itemTitle}</h2>;
};

export default HelpContentItemTitle;
