import { FC } from 'react';

import { Box, Hidden, IconButton } from '@mui/material';

type Props = {
  children: React.ReactNode
  title: string
  path: string
  isActive: boolean
}

const IconWithTextLink: FC<Props> = ({ children, title, path, isActive }) => {
  const color = isActive ? '#2699FB' : '#1D1D1F'
  const fontWeight = isActive ? 'bold' : 'regular'

  return (
    <IconButton
      aria-label="link"
      href={path}
      sx={{ color: `${color}`, display: 'flex', alignContent: 'center', borderRadius: 9999 }}
      edge="start"
    >
      {children}
      <Hidden lgDown>
        <Box
          component="span"
          ml={2}
          sx={{ fontSize: '20px', fontWeight: `${fontWeight}`, display: 'flex', borderRadius: 9999 }}
        >
          {title}
        </Box>
      </Hidden>
    </IconButton>
  )
}

export default IconWithTextLink
