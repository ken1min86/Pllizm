import { useState, VFC } from 'react';

import CloseIcon from '@mui/icons-material/Close';
import { Button, IconButton, Modal } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

const useStyles = makeStyles(() =>
  createStyles({
    container: {
      width: '100%',
      height: '100%',
      borderRadius: 16,
    },
    button: {
      padding: 0,
      borderRadius: 16,
      width: '100%',
      height: '100%',
    },
    resizedUploadedImg: {
      width: '100%',
      height: '100%',
      objectFit: 'cover',
      borderRadius: 16,
    },
    originalUploadedImg: {
      display: 'block',
      margin: 'auto',
      maxWidth: '70vw',
      maxHeight: '90vh',
    },
  }),
)

type Props = {
  uploadedImgSrc: string
}

const DisplayUploadedImgModal: VFC<Props> = ({ uploadedImgSrc }) => {
  const classes = useStyles()
  const [open, setOpen] = useState(false)
  const handleOpen = () => setOpen(true)
  const handleClose = () => setOpen(false)

  return (
    <div className={classes.container}>
      <Button onClick={handleOpen} className={classes.button}>
        <img src={uploadedImgSrc} alt="UploadedImage" className={classes.resizedUploadedImg} />
      </Button>
      <Modal open={open} onClose={handleClose} sx={{ display: 'flex', alignContent: 'center' }}>
        <>
          <IconButton
            aria-label="close"
            onClick={handleClose}
            sx={{ alignSelf: 'flex-start', color: '#f9f4ef', margin: 1 }}
          >
            <CloseIcon />
          </IconButton>
          <img src={uploadedImgSrc} alt="UploadedImage" className={classes.originalUploadedImg} />
        </>
      </Modal>
    </div>
  )
}

export default DisplayUploadedImgModal
