import { FollowRelatedButton } from 'components/atoms';
import { DefaultTemplate } from 'components/templates';
import { goBack, push } from 'connected-react-router';
import { useEffect, useState, VFC } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Users } from 'util/types/redux/users';

import ArrowBackIcon from '@mui/icons-material/ArrowBack';
import { TabContext, TabList } from '@mui/lab';
import {
    Avatar, Box, CircularProgress, Divider, Hidden, IconButton, Tab, Theme
} from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

import useRelevantUsers from '../../hooks/useRelevantUsers';
import { getUserName } from '../../reducks/users/selectors';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    title: {
      color: theme.palette.primary.main,
      fontSize: 22,
      fontWeight: 'bold',
    },
    userIcon: {
      [theme.breakpoints.down('sm')]: {
        width: 44,
        height: 44,
      },
      [theme.breakpoints.up('sm')]: {
        width: 48,
        height: 48,
      },
    },
    userProfileContainer: {
      [theme.breakpoints.up('sm')]: {
        maxWidth: '50%',
      },
    },
    userName: {
      fontSize: 14,
      wordBreak: 'break-word',
    },
    userId: {
      fontSize: 12,
      color: theme.palette.text.disabled,
      marginBottom: 8,
      wordBreak: 'break-word',
    },
    bio: {
      fontSize: 12,
      wordBreak: 'break-word',
    },
  }),
)

const useTabStyles = makeStyles((theme: Theme) =>
  createStyles({
    root: {
      color: theme.palette.text.disabled,
      fontSize: 15,
      width: '30%',
      '&:hover': {
        opacity: '0.7',
        transition: 'all 0.3s ease 0s',
      },
      '&.Mui-selected': {
        color: theme.palette.info.main,
        fontWeight: 'bold',
      },
    },
    indicator: {
      backgroundColor: 'red',
      color: 'red',
    },
  }),
)

const useTabListStyles = makeStyles((theme: Theme) =>
  createStyles({
    indicator: {
      backgroundColor: theme.palette.info.main,
    },
  }),
)

type Props = {
  location: {
    state: {
      who: 'followers' | 'usersRequestFollowingToMe' | 'usersRequestedFollowingByMe'
    }
  }
}

const RelevantUsers: VFC<Props> = ({ location }) => {
  const classes = useStyles()
  const tabClasses = useTabStyles()
  const tabListClasses = useTabListStyles()
  const dispatch = useDispatch()

  const selector = useSelector((state: { users: Users }) => state)
  const userName = getUserName(selector)

  const [tabValue, setTabValue] = useState(location.state.who)

  const { getRelevantUsers, loading, errorMessage, relevantUsers, relationship } = useRelevantUsers(
    location.state.who,
    tabValue,
  )

  useEffect(() => {
    getRelevantUsers()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabValue])

  const handleClickToBack = () => {
    dispatch(goBack())
  }

  const handleChangeTab = (
    event: React.SyntheticEvent,
    newValue: 'followers' | 'usersRequestFollowingToMe' | 'usersRequestedFollowingByMe',
  ) => {
    setTabValue(newValue)
  }

  const returnHeaderFunc = () => (
    <Box sx={{ display: 'flex', alignItems: 'center' }}>
      <IconButton aria-label="Back" sx={{ marginLeft: 0.5, marginRight: 1 }} onClick={handleClickToBack}>
        <ArrowBackIcon sx={{ color: '#2699fb' }} />
      </IconButton>
      <h1 className={classes.title}>{userName}</h1>
    </Box>
  )

  return (
    <DefaultTemplate activeNavTitle="none" returnHeaderFunc={returnHeaderFunc}>
      <Box sx={{ width: '100%' }}>
        <TabContext value={tabValue}>
          <Box sx={{ borderBottom: 1, borderColor: 'divider' }}>
            <TabList onChange={handleChangeTab} aria-label="Relevant users tabs" classes={tabListClasses} centered>
              <Tab
                label={
                  <>
                    <span>相互</span>
                    <span>フォロワー</span>
                  </>
                }
                value="followers"
                classes={tabClasses}
                wrapped
              />
              <Tab
                label={
                  <>
                    <span>ユーザーからの</span>
                    <span>フォロリク</span>
                  </>
                }
                value="usersRequestFollowingToMe"
                classes={tabClasses}
                wrapped
              />
              <Tab
                label={
                  <>
                    <span>あなたからの</span>
                    <span>フォロリク</span>
                  </>
                }
                value="usersRequestedFollowingByMe"
                classes={tabClasses}
                wrapped
              />
            </TabList>
          </Box>
          {loading && <CircularProgress color="info" />}
          {errorMessage && (
            <Box p={4} sx={{ textAlign: 'center' }}>
              {errorMessage}
            </Box>
          )}
          {relevantUsers &&
            relevantUsers.length > 0 &&
            relevantUsers.map((relevantUser) => (
              <>
                <Box key={relevantUser.user_id} sx={{ display: 'flex', padding: '8px 24px' }}>
                  <Box mr={1}>
                    <button
                      type="button"
                      onClick={() => {
                        dispatch(push(`/${relevantUser.user_id}`))
                      }}
                    >
                      <Avatar alt="User icon" src={relevantUser.icon_url} className={classes.userIcon} />
                    </button>
                  </Box>
                  <Box sx={{ display: 'flex', flexDirection: 'column' }} className={classes.userProfileContainer}>
                    <span className={classes.userName}>{relevantUser.user_name}</span>
                    <span className={classes.userId}>{relevantUser.user_id}</span>
                    <span className={classes.bio}>{relevantUser.bio}</span>
                  </Box>
                  <Hidden smDown>
                    <Box sx={{ marginLeft: 'auto' }}>
                      <FollowRelatedButton userId={relevantUser.user_id} initialStatus={relationship} />
                    </Box>
                  </Hidden>
                </Box>
                <Divider />
              </>
            ))}

          {!loading && !errorMessage && relevantUsers && relevantUsers.length === 0 && (
            <Box p={4} sx={{ textAlign: 'center', color: '#86868b' }}>
              該当するユーザーはいません。
            </Box>
          )}
        </TabContext>
      </Box>
    </DefaultTemplate>
  )
}

export default RelevantUsers
