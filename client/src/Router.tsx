import { Route, Switch } from 'react-router';
// BrowserRouterはstoreのセットアップ後に削除する
import { BrowserRouter } from 'react-router-dom';

import ReturnableHeaderTable from './components/templates/common/HeaderWithTitleAndArrow';

const Router: React.VFC = () => (
  <BrowserRouter>
    <Switch>
      <Route exact path="/">
        <ReturnableHeaderTable />
      </Route>
    </Switch>
  </BrowserRouter>
);

export default Router;
