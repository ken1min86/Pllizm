import { setErrorsAction } from './actions'
import { ErrorsList } from './types'

// eslint-disable-next-line import/prefer-default-export
export const setErrors =
  (errors: ErrorsList) =>
  (dispatch: (arg0: { type: string; payload: { list: string[] } }) => void): boolean => {
    dispatch(setErrorsAction(errors))

    return false
  }
