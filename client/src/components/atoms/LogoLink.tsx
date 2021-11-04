import { VFC } from 'react';

import { IconButton } from '@mui/material';

import Logo from '../../assets/img/LogoWithBorder.png';

type Proos = {
  width: number
  onClick: (event: React.MouseEvent<HTMLButtonElement>) => void
}

const LogoLink: VFC<Proos> = ({ width, onClick }) => (
  <IconButton edge="start" aria-label="link" onClick={onClick}>
    <img style={{ width: `${width}px`, display: 'block' }} src={Logo} alt="ロゴ" />
  </IconButton>
)

export default LogoLink
