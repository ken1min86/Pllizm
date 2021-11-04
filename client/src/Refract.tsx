import { push } from 'connected-react-router';
import { FC, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useLocation } from 'react-router';
import { getPerformedRefract } from 'reducks/users/selectors';
import { Users } from 'util/types/redux/users';

const Refract: FC = ({ children }) => {
  const dispatch = useDispatch()

  const selector = useSelector((state: { users: Users }) => state)
  const performedRefract = getPerformedRefract(selector)

  const location = useLocation().pathname

  useEffect(() => {
    if (!performedRefract && location.indexOf('/saturday')) dispatch(push('/saturday/refracts/candidates'))
    if (performedRefract && !location.indexOf('/saturday')) dispatch(push('/home'))
  }, [dispatch, location, performedRefract])

  return <>{children}</>
}

export default Refract
