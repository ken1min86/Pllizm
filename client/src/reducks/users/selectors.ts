import { createSelector } from 'reselect'

import { Users } from './types'

const usersSelector = (state: { users: Users }) => state.users

// eslint-disable-next-line import/prefer-default-export
export const getIsSignedIn = createSelector([usersSelector], (state) => state.isSignedIn)
