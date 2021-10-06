import initialState from '../store/initialState';
import * as Actions from './actions';
import { Reducer } from './types';

const UsersReducer: Reducer = (state = initialState.users, action) => {
  switch (action.type) {
    case Actions.SIGN_UP:
      return {
        ...state,
        ...action.payload,
      }
    case Actions.SIGN_IN:
      return {
        ...state,
        ...action.payload,
      }
    case Actions.SIGN_OUT:
      return {
        ...state,
        ...action.payload,
      }
    default:
      return state
  }
}

export default UsersReducer
