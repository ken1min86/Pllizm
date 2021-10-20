import { FC, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { getStatusOfRightToUsePlizm } from 'reducks/users/operations';
import { getHasRightToUsePlizm } from 'reducks/users/selectors';
import { Users } from 'util/types/redux/users';

const Restrict: FC = ({ children }) => {
  const dispatch = useDispatch()

  const selector = useSelector((state: { users: Users }) => state)
  const hasRightToUsePlizm = getHasRightToUsePlizm(selector)

  useEffect(() => {
    dispatch(getStatusOfRightToUsePlizm())
  }, [dispatch])

  if (!hasRightToUsePlizm) {
    return <></>
  }

  return <>{children}</>
}

export default Restrict
