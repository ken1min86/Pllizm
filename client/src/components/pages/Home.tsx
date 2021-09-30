import { useSelector } from 'react-redux';
import { getIcon } from 'reducks/users/selectors';

import { Users } from '../../reducks/users/types';

const Home = () => {
  // eslint-disable-next-line no-shadow
  const selector = useSelector((state: { users: Users }) => state)
  const icon = getIcon(selector)

  console.log(icon)

  return (
    <div>
      仮のコンポーネント
      <img src={icon} alt="" />
    </div>
  )
}
export default Home
