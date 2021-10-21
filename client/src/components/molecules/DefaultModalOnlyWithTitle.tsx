import { ContainedRoundedCornerButton, ErrorMessage } from 'components/atoms';
import { FC, useState } from 'react';

import { Box, Button, Modal, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    modalContainer: {
      position: 'absolute',
      top: '50%',
      left: '50%',
      transform: 'translate(-50%, -50%)',
      minWidth: 320,
      backgroundColor: theme.palette.primary.main,
      borderRadius: 4,
      padding: '40px 16px',
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
    },
    button: {
      padding: 0,
      '&:hover': {
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
      flexDirection: 'row',
      gap: 8,
    },
    errorsContainer: {
      marginBottom: 16,
    },
  }),
)

type Props = {
  title: string
  actionButtonLabel: string
  closeButtonLabel: string
  handleOnClick: (setError: React.Dispatch<React.SetStateAction<string>>) => void
  backgroundColorOfActionButton: string
}

const DefaultModalOnlyWithTitle: FC<Props> = ({
  children,
  title,
  actionButtonLabel,
  closeButtonLabel,
  handleOnClick,
  backgroundColorOfActionButton,
}) => {
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
            <ErrorMessage error={error} />
          </p>
          <Box className={classes.buttonContainer}>
            <ContainedRoundedCornerButton
              label={actionButtonLabel}
              onClick={() => handleOnClick(setError)}
              backgroundColor={`${backgroundColorOfActionButton}`}
            />
            <ContainedRoundedCornerButton label={closeButtonLabel} onClick={handleClose} backgroundColor="#86868b" />
          </Box>
        </Box>
      </Modal>
    </div>
  )
}

export default DefaultModalOnlyWithTitle
