import { Route, Switch } from 'react-router'

import Auth from './Auth'
import {
  BeginPasswordReset,
  EndPasswordReset,
  Home,
  PasswordReset,
  PrivacyPolicy,
  SentMailOfPasswordReset,
  TermsOfUse,
  Top,
} from './components/pages'

const Router: React.VFC = () => (
  <Switch>
    <Route exact path="(/)?" component={Top} />
    <Route exact path="/users/begin_password_reset" component={BeginPasswordReset} />
    <Route exact path="/users/sent_mail_of_password_reset" component={SentMailOfPasswordReset} />
    <Route exact path="/users/password_reset" component={PasswordReset} />
    <Route exact path="/users/end_password_reset" component={EndPasswordReset} />
    <Route exact path="/help/privacy_policy" component={PrivacyPolicy} />
    <Route exact path="/help/terms_of_use" component={TermsOfUse} />
    <Auth>
      <Route exact path="/home" component={Home} />
    </Auth>
  </Switch>
)

export default Router
