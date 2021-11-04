import { createSelector } from 'reselect';

import { Threads } from '../../util/types/redux/threads';

const threadsSelector = (state: { threads: Threads }) => state.threads

export const getThreadPosts = createSelector([threadsSelector], (state) => state)
