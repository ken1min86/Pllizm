import { ChangeEventHandler, VFC } from 'react'

import { TextField } from '@mui/material'
import createStyles from '@mui/styles/createStyles'
import makeStyles from '@mui/styles/makeStyles'

const useStyles = makeStyles((theme) =>
  createStyles({
    textField: {
      width: '100%',
      fontSize: '12px',
      color: theme.palette.primary.light,
    },
  }),
)

type Proos = {
  id: string
  label: string
  variant: 'standard' | 'filled' | 'outlined'
  onChange: ChangeEventHandler<HTMLInputElement | HTMLTextAreaElement>
  helperText?: string
  type?: string
  autoComplete?: string
}

const BasicTextField: VFC<Proos> = ({ id, label, variant, onChange, helperText, type, autoComplete }) => {
  const classes = useStyles()

  return (
    <TextField
      id={id}
      label={label}
      variant={variant}
      className={classes.textField}
      InputProps={{ style: { color: '#fffffe' } }}
      InputLabelProps={{ style: { fontSize: '14px' } }}
      onChange={onChange}
      helperText={helperText}
      type={type}
      autoComplete={autoComplete}
    />
  )
}

export default BasicTextField
