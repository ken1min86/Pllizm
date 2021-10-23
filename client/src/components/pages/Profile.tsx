import { FollowRelatedButton, OutlinedBlueRoundedCornerButton } from 'components/atoms';
import { PostBox } from 'components/molecules';
import { HeaderWithTitleAndDrawer, UsingCriteriaModal } from 'components/organisms';
import { DefaultTemplate } from 'components/templates';
import { push } from 'connected-react-router';
import usePostsInProfile from 'hooks/usePostsInProfile';
import useUserProfiles from 'hooks/useUserProfiles';
import { useEffect, useState, VFC } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useParams } from 'react-router';
import { Users } from 'util/types/redux/users';

import { TabContext, TabList } from '@mui/lab';
import { Avatar, Box, CircularProgress, Tab, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

import { getHasRightToUsePlizm } from '../../reducks/users/selectors';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    userIcon: {
      [theme.breakpoints.down('sm')]: {
        width: 80,
        height: 80,
      },
      [theme.breakpoints.up('sm')]: {
        width: 131,
        height: 131,
      },
    },
    userName: {
      fontWeight: 'bold',
      [theme.breakpoints.down('sm')]: {
        fontSize: 19,
      },
      [theme.breakpoints.up('sm')]: {
        fontSize: 20,
      },
    },
    userId: {
      color: theme.palette.text.disabled,
    },
    bio: {
      whiteSpace: 'pre-wrap',
      wordBreak: 'break-word',
      [theme.breakpoints.down('sm')]: {
        fontSize: 15,
      },
      [theme.breakpoints.up('sm')]: {
        fontSize: 16,
      },
    },
    countContainer: {
      display: 'flex',
      flexWrap: 'wrap',
    },
    countList: {
      color: theme.palette.text.disabled,
      marginRight: 16,
      marginBottom: 4,
      [theme.breakpoints.down('sm')]: {
        fontSize: 14,
      },
      [theme.breakpoints.up('sm')]: {
        fontSize: 15,
      },
      '&:hover': {
        cursor: 'pointer',
        opacity: '0.7',
        transition: 'all 0.3s ease 0s',
      },
    },
    countNumber: {
      color: theme.palette.text.primary,
      fontWeight: 'bold',
      marginRight: 4,
    },
  }),
)

const useTabStyles = makeStyles((theme: Theme) =>
  createStyles({
    root: {
      color: theme.palette.text.disabled,
      fontSize: 15,
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

const Profile: VFC = () => {
  const classes = useStyles()
  const tabClasses = useTabStyles()
  const tabListClasses = useTabListStyles()

  const dispatch = useDispatch()

  const selector = useSelector((state: { users: Users }) => state)
  const hasRightToUsePlizm = getHasRightToUsePlizm(selector)

  const params: { id: string } = useParams()
  const paramsId = params.id

  const [tabValue, setTabValue] = useState<'投稿' | 'リプライ' | 'ロック' | 'いいね'>('投稿')

  const { getUserProfile, activeNavTitle, errorMessageInProfile, userProfile, initialStatus } =
    useUserProfiles(paramsId)
  const { getPostsInProfile, posts, loading, errorMessageInPosts } = usePostsInProfile(tabValue)

  useEffect(() => {
    getUserProfile()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [paramsId])

  useEffect(() => {
    getPostsInProfile()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabValue])

  const handleChange = (event: React.SyntheticEvent, newValue: '投稿' | 'リプライ' | 'ロック' | 'いいね') => {
    setTabValue(newValue)
  }

  const handleClickToFollowers = () => {
    dispatch(
      push({
        pathname: '/relevant_users',
        state: { who: 'followers' },
      }),
    )
  }

  const handleClickToRelevantUsersRequestFollowToMe = () => {
    dispatch(
      push({
        pathname: '/relevant_users',
        state: { who: 'usersRequestFollowingToMe' },
      }),
    )
  }

  const handleClickToUsersRequestedFollowByMe = () => {
    dispatch(
      push({
        pathname: '/relevant_users',
        state: { who: 'usersRequestedFollowingByMe' },
      }),
    )
  }

  const Header = <HeaderWithTitleAndDrawer title={userProfile?.user_name ? userProfile.user_name : ''} />

  return (
    <DefaultTemplate activeNavTitle={activeNavTitle} Header={Header}>
      {!hasRightToUsePlizm && <UsingCriteriaModal />}
      {errorMessageInProfile && <Box sx={{ padding: 4, textAlign: 'center' }}>{errorMessageInProfile}</Box>}
      {!errorMessageInProfile && userProfile && (
        <Box sx={{ padding: 3 }}>
          <Box mb={2} sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-end' }}>
            <Avatar alt="User icon" src={userProfile.icon_url} className={classes.userIcon} />
            {userProfile.is_current_user && (
              <Box>
                <OutlinedBlueRoundedCornerButton
                  label="プロフィールを編集"
                  onClick={() => {
                    dispatch(push('/settings/profile'))
                  }}
                />
              </Box>
            )}
            {!userProfile.is_current_user && (
              <Box>
                <FollowRelatedButton userId={userProfile.user_id} initialStatus={initialStatus} />
              </Box>
            )}
          </Box>
          <Box mb={2} sx={{ display: 'flex', flexDirection: 'column' }}>
            <span className={classes.userName}>{userProfile.user_name}</span>
            <span className={classes.userId}>@{userProfile.user_id}</span>
            <span className={classes.bio}>{userProfile.bio}</span>
          </Box>
          {userProfile.is_current_user && (
            <ul className={classes.countContainer}>
              <li className={classes.countList}>
                <button type="button" onClick={handleClickToFollowers}>
                  <span className={classes.countNumber}>{userProfile.followers_count}</span>
                  相互フォロー
                </button>
              </li>
              <li className={classes.countList}>
                <button type="button" onClick={handleClickToRelevantUsersRequestFollowToMe}>
                  <span className={classes.countNumber}>{userProfile.follow_requests_to_me_count}</span>
                  ユーザーからのフォロリク
                </button>
              </li>
              <li className={classes.countList}>
                <button type="button" onClick={handleClickToUsersRequestedFollowByMe}>
                  <span className={classes.countNumber}>{userProfile.follow_requests_by_me_count}</span>
                  あなたからのフォロリク
                </button>
              </li>
            </ul>
          )}
        </Box>
      )}
      {hasRightToUsePlizm && userProfile && userProfile.is_current_user && (
        <Box sx={{ width: '100%', typography: 'body1' }}>
          <TabContext value={tabValue}>
            <Box sx={{ borderBottom: 1, borderColor: '#EEEEEE' }}>
              <TabList onChange={handleChange} aria-label="Post tabs" classes={tabListClasses}>
                <Tab label="投稿" value="投稿" sx={{ width: '25%' }} classes={tabClasses} />
                <Tab label="リプライ" value="リプライ" sx={{ width: '25%' }} classes={tabClasses} />
                <Tab label="ロック" value="ロック" sx={{ width: '25%' }} classes={tabClasses} />
                <Tab label="いいね" value="いいね" sx={{ width: '25%' }} classes={tabClasses} />
              </TabList>
            </Box>
            {loading && (
              <Box sx={{ padding: 5, textAlign: 'center' }}>
                <CircularProgress color="info" />
              </Box>
            )}
            {!errorMessageInPosts &&
              posts.length > 0 &&
              posts.map((post) => (
                <PostBox
                  postedBy={post.posted_by}
                  icon={post.icon_url}
                  postId={post.id}
                  repliesCount={post.replies_count}
                  likedByMe={post.liked_by_current_user}
                  postedAt={post.created_at}
                  status={post.status}
                  userId={post.user_id}
                  userName={post.user_name}
                  content={post.content}
                  likesCount={post.likes_count}
                  locked={post.locked}
                  image={post.image_url}
                />
              ))}
            {!errorMessageInPosts && !loading && posts.length === 0 && (
              <Box sx={{ padding: 5, textAlign: 'center', color: '#86868b' }}>
                <span>該当する投稿は存在しませんでした。</span>
              </Box>
            )}
          </TabContext>
        </Box>
      )}
    </DefaultTemplate>
  )
}

export default Profile
