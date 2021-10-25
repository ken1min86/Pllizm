import { OutlinedRoundedCornerButton } from 'components/atoms';
import { useState } from 'react';

import { Box, Modal } from '@mui/material';

const SkipRefractModal = () => {
  const [open, setOpen] = useState(false)
  const handleOpen = () => setOpen(true)
  const handleClose = () => setOpen(false)

  return (
    <>
      <Box onClick={handleOpen}>
        <OutlinedRoundedCornerButton onClick={handleOpen} label="スキップ" color="#f9f4ef" />
      </Box>
      <Modal
        open={open}
        onClose={handleClose}
        aria-labelledby="modal-modal-title"
        aria-describedby="modal-modal-description"
      >
        <Box />
        {/* <Box sx={style}>
          <Typography id="modal-modal-title" variant="h6" component="h2">
            Text in a modal
          </Typography>
          <Typography id="modal-modal-description" sx={{ mt: 2 }}>
            Duis mollis, est non commodo luctus, nisi erat porttitor ligula.
          </Typography>
        </Box> */}
      </Modal>
    </>
  )
}

export default SkipRefractModal
