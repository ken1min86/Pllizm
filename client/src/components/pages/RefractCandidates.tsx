import { DefaultTemplate } from 'components/templates';
import { VFC } from 'react';

import { Box, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

import { RefractFuncDescriptionModal } from '../organisms';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    title: {
      color: theme.palette.primary.main,
      fontSize: 22,
    },
  }),
)

const RefractCandidates: VFC = () => {
  const classes = useStyles()

  const Header = (
    <Box sx={{ width: '100%', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }} pl={3} pr={2}>
      <h1 className={classes.title}>refract</h1>
      <RefractFuncDescriptionModal type="questionButton" />
    </Box>
  )

  return (
    <DefaultTemplate activeNavTitle="refract" Header={Header} Bottom={undefined}>
      dd
    </DefaultTemplate>
  )
}

export default RefractCandidates
