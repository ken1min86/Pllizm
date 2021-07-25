/* eslint-disable prefer-arrow/prefer-arrow-functions */
import { connectRouter, routerMiddleware } from 'connected-react-router';
import { History } from 'history';
import { applyMiddleware, combineReducers, createStore as reduxCreateStore } from 'redux';

import { UsersReducer } from '../users/reducers'; // reducersのインポート

// eslint-disable-next-line @typescript-eslint/explicit-module-boundary-types
export default function createStore(history: History<unknown>) {
  // もちろんアロー関数でも良い
  return reduxCreateStore(
    // reduxライブラリからインポートしたモジュール
    combineReducers({
      router: connectRouter(history),
      // reduxライブラリからインポートしたモジュール,
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
      users: UsersReducer,
    }),
    applyMiddleware(
      // routerをmiddlewareとして使用することを宣言している。
      routerMiddleware(history),
    ),
  );
}
