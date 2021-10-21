import { ContainedRoundedCornerButton } from 'components/atoms';
import { DefaultModalOnlyWithTitle, HeaderWithBackAndTitle } from 'components/molecules';
import { DefaultTemplate } from 'components/templates';
import { VFC } from 'react';
import { useDispatch } from 'react-redux';
import { destroyAccount } from 'reducks/users/operations';

import { Box } from '@mui/material';

const DeleteAccount: VFC = () => {
  const dispatch = useDispatch()

  const handleClickToDeleteAccount = (setError: React.Dispatch<React.SetStateAction<string>>) => {
    dispatch(destroyAccount(setError))
  }

  const dummyFunc = () => false

  const returnHeaderFunc = () => <HeaderWithBackAndTitle title="アカウント削除" />

  return (
    <DefaultTemplate activeNavTitle="settings" returnHeaderFunc={returnHeaderFunc}>
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
