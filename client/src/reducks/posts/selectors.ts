import { createSelector } from 'reselect';

import { Posts } from './types';

const postsSelector = (state: { posts: Array<Posts> }) => state.posts

// eslint-disable-next-line import/prefer-default-export
export const getPosts = createSelector([postsSelector], (state) => state)
