import {
    BottomNavigationBar, NotificationOfLikeOrReply, NotificationOfRefract,
    NotificationRelatedToFollow
} from 'components/molecules';
import { HeaderWithTitleAndDrawer } from 'components/organisms';
import { DefaultTemplate } from 'components/templates';
import useNotifications from 'hooks/useNotifications';
import { useLayoutEffect, VFC } from 'react';

import { Box, CircularProgress, Hidden } from '@mui/material';

const Notifications: VFC = () => {
  document.title = '通知 / Pllizm'

  const { getNotifications, loading, error, notifications } = useNotifications()

  useLayoutEffect(() => {
    getNotifications()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  const Header = <HeaderWithTitleAndDrawer title="通知" />
  const Bottom = (
    <Hidden smUp>
      <BottomNavigationBar activeNav="notifications" />
    </Hidden>
  )

  return (
    // 備忘：アプリ使用権利の有無に応じて表示する内容を変える
    <DefaultTemplate activeNavTitle="notification" Header={Header} Bottom={Bottom}>
      {error && <Box sx={{ padding: 5, textAlign: 'center' }}>{error}</Box>}
      {loading && (
        <Box sx={{ padding: 5, textAlign: 'center' }}>
          <CircularProgress color="info" />
        </Box>
      )}
      {notifications.map((notification) => {
        let notificationComponent
        switch (notification.action) {
          case 'like':
          case 'reply':
            notificationComponent = (
              <NotificationOfLikeOrReply
                action={notification.action}
                postId={notification.post.id}
                postContent={notification.post.content}
              />
            )
            break
          case 'request':
          case 'accept':
            notificationComponent = (
              <NotificationRelatedToFollow
                action={notification.action}
                userIcon={notification.user_icon_url}
                userId={notification.user_id}
                userName={notification.user_name}
              />
            )
            break
          case 'refract':
            notificationComponent = (
              <NotificationOfRefract
                userIcon={notification.user_icon_url}
                userName={notification.user_name}
                postContent={notification.post.content}
              />
            )
            break
          default:
            break
        }

        return notificationComponent
      })}
      <Hidden smUp>
        <Box sx={{ height: 56 }} />
      </Hidden>
    </DefaultTemplate>
  )
}

export default Notifications
