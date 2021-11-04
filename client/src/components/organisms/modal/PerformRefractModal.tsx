import { ContainedRoundedCornerButton, ErrorMessage } from 'components/atoms';
import { ModalForRefract } from 'components/molecules';
import usePerformRefract from 'hooks/usePerformRefract';
import { useLayoutEffect, useState, VFC } from 'react';

import { Box, Button, Modal, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    button: {
      display: 'flex',
      justifyContent: 'center',
      alignItems: 'center',
      padding: 0,
      width: '100%',
      height: 44,
      fontWeight: 'bold',
      borderRadius: 9999,
      background:
        'linear-gradient(65deg, rgba(247, 238, 12, 1), rgba(255, 151, 29, 1) 24%, rgba(233, 94, 52, 1) 41%, rgba(154, 39, 238, 1) 80%, rgba(88, 139, 250, 1))',
      color: theme.palette.primary.light,
      '&:hover': {
        opacity: '0.7',
        transition: 'all 0.3s ease 0s',
      },
      '&:disabled': {
        color: '#86868b',
        background: '#86868b',
      },
    },
    childOfButton: {
      fontSize: '14px',
      backgroundColor: '#333333',
      borderRadius: 9999,
      width: '98%',
      height: '93%',
      display: 'flex',
      justifyContent: 'center',
      alignItems: 'center',
    },
  }),
)

type Props = {
  refractCandidateId: string
}

const PerformRefractModal: VFC<Props> = ({ refractCandidateId }) => {
  const classes = useStyles({})

  const [open, setOpen] = useState(false)
  const [disabled, setDisabled] = useState(true)

  const handleOpen = () => setOpen(true)
  const handleClose = () => setOpen(false)

  const { performRefract, errorMessage } = usePerformRefract()

  const handleClickToPerformRefract = () => {
    performRefract(refractCandidateId)
  }

  useLayoutEffect(() => {
    setDisabled(refractCandidateId === '')
  }, [refractCandidateId])

  return (
    <>
      <Button className={classes.button} onClick={handleOpen} disabled={disabled}>
        <span className={classes.childOfButton}>リフラクト</span>
      </Button>
      <Modal open={open} onClose={handleClose} aria-labelledby="modal-title">
        <ModalForRefract
          title="リフラクトを実施しますか？"
          descriptions={[
            'リフラクトをすることで選択した投稿に関するユーザーの情報を開示できます。',
            'また、この操作はやり直すことができません。',
          ]}
        >
          <Box mb={1}>
            <ErrorMessage error={errorMessage} />
          </Box>
          <Box sx={{ display: 'flex', gap: 1 }}>
            <Box sx={{ width: '50%' }}>
              <ContainedRoundedCornerButton onClick={handleClose} label="キャンセル" backgroundColor="#86868b" />
            </Box>
            <Box sx={{ width: '50%' }}>
              <Button className={classes.button} onClick={handleClickToPerformRefract}>
                <span className={classes.childOfButton}>リフラクト</span>
              </Button>
            </Box>
          </Box>
        </ModalForRefract>
      </Modal>
    </>
  )
}

export default PerformRefractModal
