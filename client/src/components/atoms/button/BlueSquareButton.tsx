import { VFC } from 'react'

import Button from '@mui/material/Button'
import createStyles from '@mui/styles/createStyles'
import makeStyles from '@mui/styles/makeStyles'

const useStyles = makeStyles((theme) =>
  createStyles({
    button: {
      backgroundColor: theme.palette.info.main,
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
}

const BlueSquareButton: VFC<Props> = ({ onClick, label }) => {
  const classes = useStyles({})

  return (
    <Button size="large" variant="contained" className={classes.button} onClick={onClick}>
      {label}
    </Button>
  )
}

export default BlueSquareButton
