import { DefaultTemplate } from 'components/templates';
import { VFC } from 'react';

import { Box, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    title: {
      fontSize: 22,
      fontWeight: 'bold',
      color: theme.palette.primary.light,
      marginLeft: 16,
    },
  }),
)

const DeletedAccount: VFC = () => {
  const classes = useStyles()

  const Header = <h1 className={classes.title}>アカウント削除</h1>

  return (
    <DefaultTemplate activeNavTitle="settings" Header={Header}>
      <Box p={3}>
        <Box component="p">アカウントが削除されました。</Box>
        <Box component="p">ご利用いただきありがとうございました。</Box>
      </Box>
    </DefaultTemplate>
  )
}

export default DeletedAccount
