import { connectRouter, routerMiddleware } from 'connected-react-router';
import {
  applyMiddleware,
  combineReducers,
  createStore as reduxCreateStore,
} from 'redux';
import thunk from 'redux-thunk';

const createStore = (history) =>
  reduxCreateStore(
    combineReducers({
      router: connectRouter(history),
    }),
    applyMiddleware(routerMiddleware(history), thunk),
  );

export default createStore;
