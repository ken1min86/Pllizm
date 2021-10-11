import { ContainedRoundedCornerButton } from 'components/atoms';
import { useState, VFC } from 'react';

import HelpIcon from '@mui/icons-material/Help';
import { Box, Button, Modal, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

import Logo from '../../assets/LogoLarge.png';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    modalContainer: {
      padding: '32px 24px',
      backgroundColor: theme.palette.primary.main,
      borderRadius: 8,
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      maxWidth: 388,
    },
    textButton: {
      fontSize: 12,
      color: theme.palette.info.main,
    },
    iconButton: {
      color: theme.palette.primary.main,
    },
    logo: {
      width: 56,
      marginBottom: 16,
      boxShadow: '0 3px 5px -5px #000',
    },
    title: {
      fontSize: 20,
      fontWeight: 'bold',
      marginBottom: 24,
    },
    contentContainer: {
      marginBottom: 32,
      fontSize: 15,
    },
    content: {
      display: 'inline-block',
      marginBottom: 4,
    },
    requiredConditionContainer: {
      color: theme.palette.warning.main,
    },
    requiredConditionListContainer: {
      marginLeft: 16,
    },
  }),
)

type Props = {
  type: 'questionButton' | 'text'
  questionButtonSize?: 'inherit' | 'large' | 'medium' | 'small'
}

const RefractFuncDescriptionModal: VFC<Props> = ({ type, questionButtonSize }) => {
  const classes = useStyles()
  const [open, setOpen] = useState(false)
  const handleOpen = () => setOpen(true)
  const handleClose = () => setOpen(false)

  return (
    <div>
      <Button onClick={handleOpen}>
        {type === 'text' && (
          <p className={classes.textButton}>
            <small>※</small>リフラクトとは
          </p>
        )}
        {type === 'questionButton' && <HelpIcon className={classes.iconButton} fontSize={questionButtonSize} />}
      </Button>
      <Modal
        open={open}
        onClose={handleClose}
        sx={{ paddingRight: 3, paddingLeft: 3, display: 'flex', justifyContent: 'center', alignItems: 'center' }}
      >
        <Box className={classes.modalContainer}>
          <img src={Logo} alt="ロゴ" className={classes.logo} />
          <h2 className={classes.title}>リフラクトとは</h2>
          <p className={classes.contentContainer}>
            <span className={classes.content}>フォロアーの投稿のうち、1件のみフォロアーの情報を開示する機能です。</span>
            <span className={classes.content}>毎週土曜日のAM5:30から使用できます。</span>
            <span className={classes.content}>また、リフラクト対象の投稿は次の条件を満たすものです。</span>
            <p className={classes.requiredConditionContainer}>
              <span className={classes.content}>
                1週間に投稿されたフォロアーの投稿のうち、ロックされておらず、かつ以下の条件いずれかを満たすもの
              </span>
              <ul className={classes.requiredConditionListContainer}>
                <li>
                  <span className={classes.content}>-あなたがいいねした投稿</span>
                </li>
                <li>
                  <span className={classes.content}>-あなたが返信した投稿</span>
                </li>
                <li>
                  <span className={classes.content}>-あなたの投稿への返信</span>
                </li>
              </ul>
            </p>
          </p>
          <Box sx={{ width: '80%' }}>
            <ContainedRoundedCornerButton onClick={handleClose} label="閉じる" backgroundColor="#86868b" />
          </Box>
        </Box>
      </Modal>
    </div>
  )
}

export default RefractFuncDescriptionModal
