import { ContainedRoundedCornerButton } from 'components/atoms';
import {
    BottomNavigationBar, DefaultModalOnlyWithTitle, HeaderWithBackAndTitle
} from 'components/molecules';
import { DefaultTemplate } from 'components/templates';
import { VFC } from 'react';
import { useDispatch } from 'react-redux';
import { destroyAccount } from 'reducks/users/operations';

import { Box, Hidden } from '@mui/material';

const DeleteAccount: VFC = () => {
  document.title = 'アカウント削除 / Pllizm'

  const dispatch = useDispatch()

  const handleClickToDeleteAccount = (setError: React.Dispatch<React.SetStateAction<string>>) => {
    dispatch(destroyAccount(setError))
  }

  const dummyFunc = () => false

  const Header = <HeaderWithBackAndTitle title="アカウント削除" />
  const Bottom = (
    <Hidden smUp>
      <BottomNavigationBar activeNav="settings" />
    </Hidden>
  )

  return (
    <DefaultTemplate activeNavTitle="settings" Header={Header} Bottom={Bottom}>
      <Box p={3}>
        <Box component="p">アカウントが削除されます。</Box>
        <Box component="p" mb={1}>
          この操作はやり直すことができません。
        </Box>
        <DefaultModalOnlyWithTitle
          title="本当に削除しますか？"
          actionButtonLabel="アカウント削除"
          closeButtonLabel="キャンセル"
          handleOnClick={(setError) => {
            handleClickToDeleteAccount(setError)
          }}
          backgroundColorOfActionButton="#e0245e"
        >
          <ContainedRoundedCornerButton
            label="アカウント削除"
            backgroundColor="#e0245e"
            disabled={false}
            onClick={dummyFunc}
          />
        </DefaultModalOnlyWithTitle>
      </Box>
    </DefaultTemplate>
  )
}

export default DeleteAccount
