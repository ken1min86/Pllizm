import initialState from '../store/initialState'
import * as Actions from './actions'
import { Reducer } from './types'

const ErrorsReducer: Reducer = (state = initialState.errors, action) => {
  switch (action.type) {
    case Actions.SET_ERRORS:
      return {
        ...state,
        ...action.payload,
      }
    default:
      return state
  }
}

export default ErrorsReducer
