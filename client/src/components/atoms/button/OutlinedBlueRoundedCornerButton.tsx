import { VFC } from 'react'

import Button from '@mui/material/Button'
import createStyles from '@mui/styles/createStyles'
import makeStyles from '@mui/styles/makeStyles'

const useStyles = makeStyles(() =>
  createStyles({
    button: {
      fontSize: '14px',
      paddingTop: '8px',
      paddingBottom: '8px',
      width: '100%',
      borderRadius: '24px',
      fontWeight: 'bold',
      border: '2px solid #2699fb',
      '&:hover': {
        opacity: '0.7',
        transition: 'all 0.3s ease 0s',
        border: '2px solid #2699fb',
      },
    },
  }),
)

type Props = {
  onClick: (event: React.MouseEvent<HTMLButtonElement>) => void
  label: string
}

const OutlinedBlueRoundedCornerButton: VFC<Props> = ({ onClick, label }) => {
  const classes = useStyles({})

  return (
    <Button color="info" className={classes.button} variant="outlined" onClick={onClick}>
      {label}
    </Button>
  )
}

export default OutlinedBlueRoundedCornerButton
