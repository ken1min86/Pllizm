import initialState from '../store/initialState';
import * as Actions from './actions';
import { Reducer } from './types';

const ThreadsReducer: Reducer = (state = initialState.threads, action) => {
  switch (action.type) {
    case Actions.GET_THREAD:
      return action.payload
    default:
      return state
  }
}

export default ThreadsReducer
