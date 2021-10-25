import {
    ContainedRoundedCornerButton, ErrorMessage, OutlinedRoundedCornerButton
} from 'components/atoms';
import { ModalForRefract } from 'components/molecules';
import useSkipRefract from 'hooks/useSkipRefract';
import { useState, VFC } from 'react';

import { Box, Modal } from '@mui/material';

const SkipRefractModal: VFC = () => {
  const [open, setOpen] = useState(false)

  const handleOpen = () => setOpen(true)
  const handleClose = () => setOpen(false)

  const { skipRefract, errorMessage } = useSkipRefract()

  return (
    <>
      <Box onClick={handleOpen}>
        <OutlinedRoundedCornerButton onClick={handleOpen} label="スキップ" color="#f9f4ef" />
      </Box>
      <Modal open={open} onClose={handleClose} aria-labelledby="modal-title">
        <ModalForRefract
          title="リフラクトをスキップしますか？"
          descriptions={[
            'スキップボタンを押すと、今週のリフラクト機能は使用されません。',
            'また、この操作はやり直すことができません。',
          ]}
        >
          <Box mb={1}>
            <ErrorMessage error={errorMessage} />
          </Box>
          <Box sx={{ display: 'flex', gap: 1 }}>
            <ContainedRoundedCornerButton onClick={handleClose} label="キャンセル" backgroundColor="#86868b" />
            <ContainedRoundedCornerButton onClick={skipRefract} label="スキップ" backgroundColor="#2699fb" />
          </Box>
        </ModalForRefract>
      </Modal>
    </>
  )
}

export default SkipRefractModal
