import { Route, Switch } from 'react-router';

import Auth from './Auth';
import {
    AccountSetting, BeginPasswordReset, EditProfile, EndPasswordReset, Home, PasswordReset,
    PostDetail, PrivacyPolicy, Profile, RelevantUsers, Search, SentMailOfPasswordReset, TermsOfUse,
    Top
} from './components/pages';

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
      <Switch>
        <Route exact path="/home" component={Home} />
        <Route exact path="/posts/:id" component={PostDetail} />
        <Route exact path="/search" component={Search} />
        <Route exact path="/settings/account" component={AccountSetting} />
        <Route exact path="/settings/profile" component={EditProfile} />
        <Route exact path="/relevant_users" component={RelevantUsers} />
        <Route exact path="/:id" component={Profile} />
      </Switch>
    </Auth>
  </Switch>
)

export default Router
