import { ContainedGrayRoundedCornerButton, ErrorMessages } from 'components/atoms';
import { FC, useState } from 'react';

import { Box, Button, Modal, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

import ContainedBlueRoundedCornerButton from '../atoms/button/ContainedBlueRoundedCornerButton';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    modalContainer: {
      position: 'absolute',
      top: '50%',
      left: '50%',
      transform: 'translate(-50%, -50%)',
      minWidth: 300,
      backgroundColor: theme.palette.primary.main,
      borderRadius: 4,
      padding: '32px 56px',
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
    },
    button: {
      padding: 16,
      backgroundColor: '#333333',
      '&:hover': {
        backgroundColor: '#333333',
        opacity: '0.7',
        transition: 'all 0.3s ease 0s',
      },
    },
    title: {
      fontSize: 20,
      fontWeight: 'bold',
      marginBottom: 40,
    },
    buttonContainer: {
      width: '100%',
      display: 'flex',
      flexDirection: 'column',
    },
    spacer: {
      display: 'block',
      height: 8,
    },
    errorsContainer: {
      marginBottom: 16,
    },
  }),
)

type Props = {
  title: string
  actionLabel: string
  closeLabel: string
  handleOnClick: (setError: React.Dispatch<React.SetStateAction<string>>) => void
}

const DefaultModalOnlyWithTitle: FC<Props> = ({ children, title, actionLabel, closeLabel, handleOnClick }) => {
  const classes = useStyles()
  const [open, setOpen] = useState(false)
  const handleOpen = () => setOpen(true)
  const handleClose = () => setOpen(false)
  const [error, setError] = useState('')

  return (
    <div>
      <Button className={classes.button} onClick={handleOpen}>
        {children}
      </Button>
      <Modal
        open={open}
        onClose={handleClose}
        aria-labelledby="modal-modal-title"
        aria-describedby="modal-modal-description"
      >
        <Box className={classes.modalContainer}>
          <h2 className={classes.title}>{title}</h2>
          <p className={classes.errorsContainer}>
            <ErrorMessages errors={[error]} />
          </p>
          <Box className={classes.buttonContainer}>
            <ContainedBlueRoundedCornerButton label={actionLabel} onClick={() => handleOnClick(setError)} />
            <span className={classes.spacer} />
            <ContainedGrayRoundedCornerButton label={closeLabel} onClick={handleClose} />
          </Box>
        </Box>
      </Modal>
    </div>
  )
}

export default DefaultModalOnlyWithTitle
