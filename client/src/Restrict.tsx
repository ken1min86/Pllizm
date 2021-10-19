import { FC, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { listenAuthState } from 'reducks/users/operations';
import { getIsSignedIn } from 'reducks/users/selectors';
import { Users } from 'util/types/redux/users';

// Authのコピーをしただけなので実装は未完成
const Restrict: FC = ({ children }) => {
  const dispatch = useDispatch()
  const selector = useSelector((state: { users: Users }) => state)

  const isSignedIn = getIsSignedIn(selector)

  useEffect(() => {
    if (!isSignedIn) {
      dispatch(listenAuthState())
    }
  }, [dispatch, isSignedIn])

  if (!isSignedIn) {
    return <></>
  }

  return <>{children}</>
}

export default Restrict