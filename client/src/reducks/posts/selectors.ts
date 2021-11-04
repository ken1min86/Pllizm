import { createSelector } from 'reselect';

import { PostsOfMeAndFollower } from '../../util/types/redux/posts';

const postsSelector = (state: { posts: Array<PostsOfMeAndFollower> }) => state.posts

export const getPosts = createSelector([postsSelector], (state) => state)
