import { GetThreadAction } from '../../util/types/redux/threads';

export const GET_THREAD = 'GET_THREAD'
export const getThreadAction: GetThreadAction = (thread) => ({
  type: 'GET_THREAD',
  payload: thread,
})
