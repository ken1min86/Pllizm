import { createSelector } from 'reselect';

import { Users } from './types';

const usersSelector = (state: { users: Users }) => state.users

export const getIsSignedIn = createSelector([usersSelector], (state) => state.isSignedIn)
export const getIcon = createSelector([usersSelector], (state) => state.icon)
