import { Route, Switch } from 'react-router';

import { PrivacyPolicy, TermsOfUse } from './components/pages/index';

const Router: React.VFC = () => (
  <Switch>
    <Route exact path="/help/terms_of_use" component={TermsOfUse} />
    <Route exact path="/help/privacy_policy" component={PrivacyPolicy} />
  </Switch>
);

export default Router;
