import { VFC } from 'react';

import { createStyles, makeStyles } from '@material-ui/core/styles';

const useStyles = makeStyles((theme) =>
  createStyles({
    p: {
      fontSize: '16px',
      marginLeft: '24px',
      [theme.breakpoints.down('xs')]: {
        fontSize: '12px',
        marginLeft: '8px',
      },
    },
  }),
);

const HelpContentPremiseDescription: VFC<{ description: string }> = ({
  description,
}) => {
  const classes = useStyles();

  return <p className={classes.p}>{description}</p>;
};

export default HelpContentPremiseDescription;
