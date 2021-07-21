import './index.css';
import './styles/reset.css';

// import { ConnectedRouter } from 'connected-react-router';
// import * as History from 'history';
import React from 'react';
import ReactDOM from 'react-dom';

// import { Provider } from 'react-redux';
import { ThemeProvider } from '@material-ui/core';

import App from './App';
// import createStore from './reducks/store/store';
import reportWebVitals from './reportWebVitals';
import theme from './styles/theme';

// const history = History.createBrowserHistory();
// eslint-disable-next-line import/prefer-default-export
// export const store = createStore(history);

ReactDOM.render(
  <React.StrictMode>
    {/* <Provider store={store}> */}
    {/* <ConnectedRouter history={history}> */}
    <ThemeProvider theme={theme}>
      <App />
    </ThemeProvider>
    {/* </ConnectedRouter> */}
    {/* </Provider> */}
  </React.StrictMode>,
  document.getElementById('root'),
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
