import { connectRouter, routerMiddleware } from 'connected-react-router';
import { History } from 'history';
import PostsReducer from 'reducks/posts/reducers';
import { applyMiddleware, combineReducers, createStore as reduxCreateStore } from 'redux';
import thunk from 'redux-thunk';

import UsersReducer from '../users/reducers';

// eslint-disable-next-line @typescript-eslint/explicit-module-boundary-types
const createStore = (history: History<unknown>) =>
  reduxCreateStore(
    combineReducers({
      router: connectRouter(history),
      users: UsersReducer,
      posts: PostsReducer,
    }),
    applyMiddleware(routerMiddleware(history), thunk),
  )

export default createStore
