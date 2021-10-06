import createTheme from '@mui/material/styles/createTheme';

const theme = createTheme({
  palette: {
    primary: {
      light: '#fffffe',
      main: '#f9f4ef',
    },
    secondary: {
      main: 'rgba(0, 0, 0, 0.8)',
    },
    warning: {
      main: '#e0245e',
    },
    info: {
      main: '#2699fb',
    },
    background: {
      default: 'rgba(123, 123, 123, 0.4)',
    },
    text: {
      primary: '#1d1d1f',
      secondary: 'rgba(255, 255, 255, 0.72)',
      disabled: '#86868b',
    },
  },
  breakpoints: {
    values: {
      xs: 0, // スマホ用
      sm: 600, // タブレット用
      md: 1025, // PC用
      lg: 1200,
      xl: 1920,
    },
  },
  typography: {
    button: {
      textTransform: 'none', // ボタン内アルファベット文字を大文字変換しない
    },
  },
})

export default theme
