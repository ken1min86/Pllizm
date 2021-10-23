import Auth from 'Auth';
import { Route, Switch } from 'react-router';
import Restrict from 'Restrict';

import {
    About, AccountSetting, BeginPasswordReset, ChangeEmail, ChangePassword, ChangeUserId,
    DeleteAccount, DeletedAccount, EditProfile, EndPasswordReset, Home, PasswordReset, PostDetail,
    PrivacyPolicy, Profile, RefractCandidates, RelevantUsers, Search, SentMailOfPasswordReset,
    TermsOfUse, Top
} from './components/pages';

const Router: React.VFC = () => (
  <Switch>
    <Route exact path="(/)?" component={Top} />
    <Route exact path="/about" component={About} />
    <Route exact path="/users/begin_password_reset" component={BeginPasswordReset} />
    <Route exact path="/users/sent_mail_of_password_reset" component={SentMailOfPasswordReset} />
    <Route exact path="/users/password_reset" component={PasswordReset} />
    <Route exact path="/users/end_password_reset" component={EndPasswordReset} />
    <Route exact path="/help/privacy_policy" component={PrivacyPolicy} />
    <Route exact path="/help/terms_of_use" component={TermsOfUse} />
    <Route exact path="/settings/deactivated" component={DeletedAccount} />

    <Auth>
      <Switch>
        <Route exact path="/relevant_users" component={RelevantUsers} />
        <Route exact path="/search" component={Search} />
        <Route exact path="/settings/account" component={AccountSetting} />
        <Route exact path="/settings/deactivate" component={DeleteAccount} />
        <Route exact path="/settings/email" component={ChangeEmail} />
        <Route exact path="/settings/password" component={ChangePassword} />
        <Route exact path="/settings/profile" component={EditProfile} />
        <Route exact path="/settings/user_id" component={ChangeUserId} />
        <Route exact path="/users/:id" component={Profile} />
        <Restrict>
          <Route exact path="/saturday/refracts/candidates" component={RefractCandidates} />
          <Route exact path="/home" component={Home} />
          <Route exact path="/posts/:id" component={PostDetail} />
        </Restrict>
      </Switch>
    </Auth>
  </Switch>
)

export default Router
