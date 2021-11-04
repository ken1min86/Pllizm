import { connectRouter, routerMiddleware } from 'connected-react-router';
import { History } from 'history';
import PostsReducer from 'reducks/posts/reducers';
import ThreadsReducer from 'reducks/threads/reducers';
import { applyMiddleware, combineReducers, createStore as reduxCreateStore } from 'redux';
import thunk from 'redux-thunk';

import UsersReducer from '../users/reducers';

const createStore = (history: History<any>) =>
  reduxCreateStore(
    combineReducers({
      router: connectRouter(history),
      users: UsersReducer,
      posts: PostsReducer,
      threads: ThreadsReducer,
    }),
    applyMiddleware(routerMiddleware(history), thunk),
  )

export default createStore
