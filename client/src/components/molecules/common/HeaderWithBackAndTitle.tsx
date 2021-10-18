import { goBack } from 'connected-react-router';
import { VFC } from 'react';
import { useDispatch } from 'react-redux';

import ArrowBackIcon from '@mui/icons-material/ArrowBack';
import { Box, IconButton, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    title: {
      color: theme.palette.primary.main,
      fontSize: 22,
      fontWeight: 'bold',
    },
  }),
)

type Props = {
  title: string
}

const HeaderWithBackAndTitle: VFC<Props> = ({ title }) => {
  const classes = useStyles()
  const dispatch = useDispatch()

  const handleClickToBack = () => {
    dispatch(goBack())
  }

  return (
    <Box sx={{ display: 'flex', alignItems: 'center' }}>
      <IconButton aria-label="Back" sx={{ marginLeft: 0.5, marginRight: 1 }} onClick={handleClickToBack}>
        <ArrowBackIcon sx={{ color: '#2699fb' }} />
      </IconButton>
      <h1 className={classes.title}>{title}</h1>
    </Box>
  )
}

export default HeaderWithBackAndTitle
