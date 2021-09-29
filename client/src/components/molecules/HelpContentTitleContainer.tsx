import { VFC } from 'react'

import { Box } from '@mui/material'

import { HelpContentPremiseDescription, HelpContentTitle } from '../atoms/index'

const HelpContentTitleContainer: VFC<{ title: string; description: string }> = ({ title, description }) => (
  <Box mb={4}>
    <HelpContentTitle title={title} />
    <HelpContentPremiseDescription description={description} />
  </Box>
)

export default HelpContentTitleContainer
