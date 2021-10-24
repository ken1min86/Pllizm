import { push } from 'connected-react-router';
import { FC, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { getPerformedRefract } from 'reducks/users/selectors';
import { Users } from 'util/types/redux/users';

const Refract: FC = ({ children }) => {
  const dispatch = useDispatch()
  const selector = useSelector((state: { users: Users }) => state)
  const performedRefract = getPerformedRefract(selector)

  useEffect(() => {
    if (!performedRefract) dispatch(push('/refract_candidates'))
  }, [dispatch, performedRefract])

  if (!performedRefract) return <></>

  return <>{children}</>
}

export default Refract
