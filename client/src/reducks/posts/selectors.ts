import { createSelector } from 'reselect';

import { PostsOfMeAndFollower } from './types';

const postsSelector = (state: { posts: Array<PostsOfMeAndFollower> }) => state.posts

export const getPosts = createSelector([postsSelector], (state) => state)
