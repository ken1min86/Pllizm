import { VFC } from 'react';

import Button from '@mui/material/Button';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

const useStyles = makeStyles(() =>
  createStyles({
    button: {
      fontSize: '14px',
      paddingTop: '8px',
      paddingBottom: '8px',
      width: '100%',
      borderRadius: '24px',
      fontWeight: 'bold',
      '&:hover': {
        opacity: '0.7',
        transition: 'all 0.3s ease 0s',
      },
    },
  }),
)

type Props = {
  onClick: (event: React.MouseEvent<HTMLButtonElement>) => void
  label: string
  color: string
}

const OutlinedBlueRoundedCornerButton: VFC<Props> = ({ onClick, label, color }) => {
  const classes = useStyles({})

  return (
    <Button
      className={classes.button}
      variant="outlined"
      onClick={onClick}
      sx={{ color: `${color}`, border: `2px solid ${color}`, '&:hover': { border: `2px solid ${color}` } }}
    >
      {label}
    </Button>
  )
}

export default OutlinedBlueRoundedCornerButton
