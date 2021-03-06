import { createSelector } from 'reselect';

import { Users } from '../../util/types/redux/users';

const usersSelector = (state: { users: Users }) => state.users

export const getUser = createSelector([usersSelector], (state) => state)
export const getIcon = createSelector([usersSelector], (state) => state.icon)
export const getIsSignedIn = createSelector([usersSelector], (state) => state.isSignedIn)
export const getUserId = createSelector([usersSelector], (state) => state.userId)
export const getUserName = createSelector([usersSelector], (state) => state.userName)
export const getNeedDescriptionAboutLock = createSelector([usersSelector], (state) => state.needDescriptionAboutLock)
export const getHasRightToUsePllizm = createSelector([usersSelector], (state) => state.hasRightToUsePllizm)
export const getPerformedRefract = createSelector([usersSelector], (state) => state.performedRefract)
