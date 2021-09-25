import { createSelector } from 'reselect'

import { Errors } from './types'

const errorsSelector = (state: { errors: Errors }): Errors => state.errors

// eslint-disable-next-line import/prefer-default-export
export const getErrors = createSelector([errorsSelector], (state) => state.list)
