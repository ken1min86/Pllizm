import { createStyles, makeStyles } from '@material-ui/core/styles';
import ArrowBackIcon from '@material-ui/icons/ArrowBack';

const useStyles = makeStyles(() =>
  createStyles({
    button: {
      backgroundColor: 'green',
    },
  }),
);

const ReturnArrow: React.VFC = () => {
  const classes = useStyles();

  // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
  return <ArrowBackIcon className={classes.button} />;
};

type Props = {
  title: string;
};

const PageTitle: React.VFC<Props> = ({ title }) => <div>{title}</div>;

const ReturnableHeaderTable: React.VFC = () => (
  <header>
    <ReturnArrow />
    <PageTitle title="利用規約" />
  </header>
);

export default ReturnableHeaderTable;
