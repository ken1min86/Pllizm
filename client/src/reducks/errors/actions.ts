import { ErrorsAction } from './types'

export const SET_ERRORS = 'SET_ERRORS'
export const setErrorsAction: ErrorsAction = (errors) => ({
  type: 'SET_ERRORS',
  payload: {
    list: errors,
  },
})
