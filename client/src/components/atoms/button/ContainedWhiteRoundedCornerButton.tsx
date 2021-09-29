/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
import { VFC } from 'react'

import { Theme } from '@mui/material'
import Button from '@mui/material/Button'
import createStyles from '@mui/styles/createStyles'
import makeStyles from '@mui/styles/makeStyles'

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    button: {
      fontSize: '14px',
      paddingTop: '8px',
      paddingBottom: '8px',
      width: '100%',
      borderRadius: '24px',
      color: theme.palette.info.main,
      border: '1px solid #2699fb',
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
}

const ContainedWhiteRoundedCornerButton: VFC<Props> = ({ onClick, label }) => {
  const classes = useStyles({})

  return (
    <Button className={classes.button} variant="contained" onClick={onClick} style={{ backgroundColor: '#fffffe' }}>
      {label}
    </Button>
  )
}

export default ContainedWhiteRoundedCornerButton
