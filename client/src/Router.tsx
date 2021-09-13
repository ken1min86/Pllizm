import { Route, Switch } from 'react-router';

import TermsOfUse from './components/templates/common/TermsOfUse';

const Router: React.VFC = () => (
  <Switch>
    <Route exact path="/help/terms_of_use" component={TermsOfUse} />
    <Route exact path="/help/privacy_policy" component={TermsOfUse} />
  </Switch>
);

export default Router;
