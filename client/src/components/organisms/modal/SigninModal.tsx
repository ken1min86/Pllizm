import {
    BasicTextField, BlueSquareButton, ErrorMessage, OutlinedRoundedCornerButton
} from 'components/atoms';
import { useCallback, useState, VFC } from 'react';
import Modal from 'react-modal';
import { useDispatch } from 'react-redux';
import { Link } from 'react-router-dom';
import { signIn } from 'reducks/users/operations';

import CancelIcon from '@mui/icons-material/Cancel';
import { Box, IconButton, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

// eslint-disable-next-line import/no-useless-path-segments
import { SignupModal } from '../';
import Logo from '../../../assets/img/PopupHeaderLogo.png';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    main: {
      padding: '32px 40px',
      backgroundColor: theme.palette.background.default,
      height: '100%',
      display: 'flex',
      justifyContent: 'center',
      alignItems: 'center',
    },
    popupContainer: {
      position: 'relative',
      backgroundColor: '#1b1b1b',
      padding: '32px 38px',
      maxWidth: '320px',
      borderRadius: '6px',
    },
    closeButton: {
      position: 'absolute',
      top: '4px',
      right: '4px',
    },
    popupTitle: {
      color: theme.palette.primary.light,
      fontSize: '20px',
      fontWeight: 'bold',
    },
    textField: {
      width: '100%',
      fontSize: '12px',
      color: theme.palette.primary.light,
    },
    signUpText: {
      fontSize: '12px',
      color: theme.palette.primary.light,
      marginLeft: -10,
      marginRight: -10,
    },
    link: {
      color: theme.palette.info.main,
      textDecoration: 'underline',
    },
    agreementText: {
      fontSize: '10px',
      color: theme.palette.text.secondary,
    },
    content: {
      width: '100%',
      height: '100%',
    },
    signInLink: {
      fontSize: '12px',
      color: theme.palette.info.main,
      textDecoration: 'underline',
    },
    forgetPassword: {
      fontSize: '12px',
      color: theme.palette.text.secondary,
      textDecoration: 'underline',
      marginBottom: 16,
    },
  }),
)

Modal.setAppElement('#root')

type Props = {
  type: 'text' | 'button'
}

const SigninModal: VFC<Props> = ({ type }) => {
  const classes = useStyles()
  const dispatch = useDispatch()

  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [modalIsOpen, setModalIsOpen] = useState(false)
  const [error, setError] = useState('')

  const openModal = () => {
    setModalIsOpen(true)
  }

  const closeModal = () => {
    setModalIsOpen(false)
  }

  const inputEmail = useCallback(
    (event) => {
      // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
      setEmail(event.target.value)
    },
    [setEmail],
  )

  const inputPassword = useCallback(
    (event) => {
      // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
      setPassword(event.target.value)
    },
    [setPassword],
  )

  return (
    <>
      {type === 'button' && (
        <OutlinedRoundedCornerButton
          label="ログイン"
          onClick={openModal}
          color="#2699fb"
          data-testid="signin-link-in-button"
        />
      )}
      {type === 'text' && (
        <button type="button" className={classes.signInLink} onClick={openModal} data-testid="signin-link-in-text">
          ログイン
        </button>
      )}
      <Modal isOpen={modalIsOpen} onRequestClose={closeModal} className={classes.content} contentLabel="login Modal">
        <Box className={classes.main}>
          <Box className={classes.popupContainer}>
            <IconButton
              aria-label="close"
              className={classes.closeButton}
              size="large"
              onClick={closeModal}
              data-testid="close-button"
            >
              <CancelIcon />
            </IconButton>
            <Box mb={2} textAlign="center">
              <img src={Logo} alt="ロゴ" />
            </Box>
            <Box mb={3} textAlign="center">
              <p className={classes.popupTitle} data-testid="title">
                ログイン
              </p>
            </Box>
            <Box mb={1}>
              <BasicTextField
                id="outlined-helperText"
                label="メールアドレス"
                variant="outlined"
                onChange={inputEmail}
              />
            </Box>
            <Box mb={1}>
              <BasicTextField
                id="outlined-password-input"
                label="パスワード"
                type="password"
                autoComplete="password"
                variant="outlined"
                onChange={inputPassword}
              />
            </Box>
            <Link to="/users/begin_password_reset" className={classes.forgetPassword}>
              パスワードをお忘れの方はこちら
            </Link>
            <Box mb={2}>
              <ErrorMessage error={error} />
            </Box>
            <Box mb={2}>
              <BlueSquareButton
                label="ログイン"
                size="large"
                onClick={() => {
                  dispatch(signIn(email, password, setError))
                }}
              />
            </Box>
            <Box className={classes.signUpText} mb={3}>
              アカウントをお持ちでない方は
              <SignupModal type="text" />へ
            </Box>
            <Box className={classes.agreementText}>
              ※利用開始をもって
              <Link to="/help/terms_of_use" className={classes.link} data-testid="terms-of-use-link-in-modal">
                利用規約
              </Link>
              と
              <Link to="/help/privacy_policy" className={classes.link} data-testid="privacy-policy-link-in-modal">
                プライバシーポリシー
              </Link>
              に同意したものとみなします。
            </Box>
          </Box>
        </Box>
      </Modal>
    </>
  )
}

export default SigninModal
