import { SigninModal, SignupModal } from 'components/organisms';

import { Box } from '@mui/material';

const Top = () => (
  <>
    <Box mb={2}>
      <SignupModal type="button" />
    </Box>
    <Box>
      <SigninModal type="button" />
    </Box>
  </>
)

export default Top
