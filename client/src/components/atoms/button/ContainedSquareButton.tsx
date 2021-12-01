import { VFC } from 'react';

import { Theme } from '@mui/material';
import Button from '@mui/material/Button';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    button: {
      width: '100%',
      color: theme.palette.primary.light,
      fontWeight: 'bold',
      '&:hover': {
        backgroundColor: theme.palette.info.main,
        opacity: '0.7',
        transition: 'all 0.3s ease 0s',
      },
    },
  }),
)

type Props = {
  onClick: (event: React.MouseEvent<HTMLButtonElement>) => void
  label: string
  size: 'small' | 'medium' | 'large'
  buttonColor: string
}

const ContainedSquareButton: VFC<Props> = ({ onClick, label, size, buttonColor }) => {
  const classes = useStyles({})

  return (
    <Button
      variant="contained"
      size={size}
      className={classes.button}
      style={{ backgroundColor: buttonColor }}
      onClick={onClick}
    >
      {label}
    </Button>
  )
}

export default ContainedSquareButton
