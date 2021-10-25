import { RefractFuncDescriptionModal } from 'components/organisms';
import { FC } from 'react';

import { Box, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    modalContainer: {
      position: 'absolute',
      top: '50%',
      left: '50%',
      transform: 'translate(-50%, -50%)',
      borderRadius: 8,
      backgroundColor: theme.palette.primary.main,
      width: 'min(327px, 95vw)',
      padding: '40px 24px 24px 24px',
    },
    title: {
      fontSize: 20,
      fontWeight: 'bold',
      marginBottom: 24,
    },
    description: {
      display: 'inline-block',
      fontSize: 14,
    },
  }),
)

type Props = {
  title: string
  descriptions: Array<string>
}

const ModalForRefract: FC<Props> = ({ title, descriptions, children }) => {
  const classes = useStyles()

  return (
    <Box className={classes.modalContainer}>
      <h2 id="modal-title" className={classes.title}>
        {title}
      </h2>
      <Box mb={6}>
        {descriptions.map((description) => (
          <span className={classes.description}>{description}</span>
        ))}
      </Box>
      {children}
      <Box sx={{ marginLeft: 'auto', width: 100, marginTop: 2 }}>
        <RefractFuncDescriptionModal type="text" />
      </Box>
    </Box>
  )
}

export default ModalForRefract
