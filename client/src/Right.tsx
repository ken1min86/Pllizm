import { push } from 'connected-react-router';
import { FC, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { getHasRightToUsePllizm } from 'reducks/users/selectors';
import { Users } from 'util/types/redux/users';

const Right: FC = ({ children }) => {
  const dispatch = useDispatch()
  const selector = useSelector((state: { users: Users }) => state)
  const hasRightToUsePllizm = getHasRightToUsePllizm(selector)

  useEffect(() => {
    if (!hasRightToUsePllizm) dispatch(push('/search'))
  }, [dispatch, hasRightToUsePllizm])

  if (!hasRightToUsePllizm) return <></>

  return <>{children}</>
}

export default Right
