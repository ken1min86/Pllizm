import { Route, Switch } from 'react-router'

import Auth from './Auth'
import { Home, PrivacyPolicy, TermsOfUse, Top } from './components/pages/index'

const Router: React.VFC = () => (
  <Switch>
    <Route exact path="(/)?" component={Top} />
    <Route exact path="/help/privacy_policy" component={PrivacyPolicy} />
    <Route exact path="/help/terms_of_use" component={TermsOfUse} />
    <Auth>
      <Route exact path="/home" component={Home} />
    </Auth>
  </Switch>
)

export default Router
