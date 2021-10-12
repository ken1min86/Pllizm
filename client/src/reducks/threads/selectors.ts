import { createSelector } from 'reselect';

import { Threads } from './types';

const threadsSelector = (state: { threads: Threads }) => state.threads

export const getThreadPosts = createSelector([threadsSelector], (state) => state)
