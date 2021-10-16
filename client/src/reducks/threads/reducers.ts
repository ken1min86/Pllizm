import { Reducer } from '../../util/types/redux/threads';
import initialState from '../store/initialState';
import * as Actions from './actions';

const ThreadsReducer: Reducer = (state = initialState.threads, action) => {
  switch (action.type) {
    case Actions.GET_THREAD:
      return action.payload
    default:
      return state
  }
}

export default ThreadsReducer
