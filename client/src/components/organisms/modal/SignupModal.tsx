import {
    BasicTextField, ContainedRoundedCornerButton, ContainedSquareButton, ErrorMessage
} from 'components/atoms';
import { useCallback, useState, VFC } from 'react';
import Modal from 'react-modal';
import { useDispatch } from 'react-redux';
import { Link } from 'react-router-dom';
import { signUp } from 'reducks/users/operations';

import CancelIcon from '@mui/icons-material/Cancel';
import { Box, IconButton, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

// eslint-disable-next-line import/no-useless-path-segments
import { SigninModal } from '../';
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
      color: 'rgba(123, 123, 123, 0.4)',
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

    loginText: {
      fontSize: '12px',
      color: theme.palette.primary.light,
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
    signUpLink: {
      fontSize: '12px',
      color: theme.palette.info.main,
      textDecoration: 'underline',
    },
  }),
)

Modal.setAppElement('#root')

type Props = {
  type: 'text' | 'button'
}

const SignupModal: VFC<Props> = ({ type }) => {
  const classes = useStyles()
  const dispatch = useDispatch()

  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [passwordConfirmation, setPasswordConfirmation] = useState('')
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

  const inputPasswordConfirmation = useCallback(
    (event) => {
      // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
      setPasswordConfirmation(event.target.value)
    },
    [setPasswordConfirmation],
  )

  return (
    <>
      {type === 'button' && (
        <ContainedRoundedCornerButton
          label="アカウント作成"
          onClick={openModal}
          backgroundColor="#2699fb"
          data-testid="signup-link-in-button"
        />
      )}
      {type === 'text' && (
        <button type="button" className={classes.signUpLink} onClick={openModal} data-testid="signup-link-in-text">
          アカウント作成
        </button>
      )}
      <Modal isOpen={modalIsOpen} onRequestClose={closeModal} className={classes.content} contentLabel="SignUp Modal">
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
                アカウント作成
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
                helperText="8文字以上で設定してください"
                type="password"
                autoComplete="password"
                variant="outlined"
                onChange={inputPassword}
              />
            </Box>
            <Box mb={1} width="100%">
              <BasicTextField
                id="outlined-password-input"
                label="パスワード(確認)"
                type="password"
                autoComplete="password"
                variant="outlined"
                onChange={inputPasswordConfirmation}
              />
            </Box>
            <Box mb={2}>
              <ErrorMessage error={error} />
            </Box>
            <Box mb={2}>
              <ContainedSquareButton
                label="アカウント作成"
                size="large"
                buttonColor="#2699fb"
                onClick={() => {
                  dispatch(signUp(email, password, passwordConfirmation, setError))
                }}
              />
            </Box>
            <Box className={classes.loginText} mb={3}>
              すでにアカウントをお持ちの方は
              <SigninModal type="text" />へ
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

export default SignupModal
