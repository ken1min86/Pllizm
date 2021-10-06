import { VFC } from 'react';

import { Box } from '@mui/material';

import { HelpContentPremiseDescription, HelpContentTitle } from '../atoms/index';

type Props = {
  title: string
  description: string
}

const HelpContentTitleContainer: VFC<Props> = ({ title, description }) => (
  <Box mb={4}>
    <HelpContentTitle title={title} />
    <HelpContentPremiseDescription description={description} />
  </Box>
)

export default HelpContentTitleContainer
