import { Reducer } from '../../util/types/redux/posts';
import initialState from '../store/initialState';
import * as Actions from './actions';

const PostsReducer: Reducer = (state = initialState.posts, action) => {
  switch (action.type) {
    case Actions.GET_POSTS_OF_ME_AND_FOLLOWER:
      return [...action.payload]
    default:
      return state
  }
}

export default PostsReducer
