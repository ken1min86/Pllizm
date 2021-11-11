import { BottomNavigationBar, PostBox } from 'components/molecules';
import { AccountDrawer, RefractFuncDescriptionModal } from 'components/organisms';
import { DefaultTemplate } from 'components/templates';
import useRefracts from 'hooks/useRefracts';
import { useLayoutEffect, useState, VFC } from 'react';
import { formatTimeOfRfc3339ToDate } from 'util/functions/common';

import { TabContext, TabList, TabPanel } from '@mui/lab';
import { Box, CircularProgress, Hidden, Tab, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

import Logo from '../../../assets/img/HeaderLogo.png';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    title: {
      color: theme.palette.primary.main,
      fontSize: 22,
      [theme.breakpoints.up('sm')]: {
        marginLeft: 16,
      },
    },
    img: {
      width: 28,
      position: 'absolute',
      display: 'block',
      left: 'calc( 50% - 14px )',
    },
    refractedAt: {
      backgroundColor: theme.palette.text.disabled,
      width: '100%',
      padding: 4,
      textAlign: 'center',
      color: theme.palette.text.secondary,
    },
  }),
)

const useTabStyles = makeStyles((theme: Theme) =>
  createStyles({
    root: {
      color: theme.palette.text.disabled,
      fontSize: 15,
      padding: 0,
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
    flexContainer: {
      display: 'flex',
      justifyContent: 'space-around',
    },
    indicator: {
      backgroundColor: theme.palette.info.main,
    },
  }),
)

const RefractedPosts: VFC = () => {
  document.title = 'リフラクト / Pllizm'

  const classes = useStyles()
  const tabClasses = useTabStyles()
  const tabListClasses = useTabListStyles()

  const {
    getRefractsPerformedByMe,
    getRefractsPerformedByFollower,
    refractsPeformedByMe,
    refractsPeformedByFollower,
    loadingOfMe,
    loadingOfFollower,
    errorOfMe,
    errorOfFollower,
  } = useRefracts()

  const [tabValue, setTabValue] = useState<'me' | 'follower'>('me')

  const handleChangeTab = (event: React.SyntheticEvent, newValue: 'me' | 'follower') => {
    setTabValue(newValue)
  }

  useLayoutEffect(() => {
    getRefractsPerformedByMe()
    getRefractsPerformedByFollower()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  const Header = (
    <Box sx={{ width: '100%', display: 'flex', alignItems: 'center' }}>
      <Hidden smUp>
        <AccountDrawer />
        <img className={classes.img} src={Logo} alt="ロゴ" />
      </Hidden>
      <Hidden smDown>
        <h1 className={classes.title}>refract</h1>
      </Hidden>
      <Box mr={2} sx={{ marginLeft: 'auto' }}>
        <RefractFuncDescriptionModal type="questionButton" />
      </Box>
    </Box>
  )

  const Bottom = (
    <Hidden smUp>
      <BottomNavigationBar activeNav="refract" />
    </Hidden>
  )

  return (
    <DefaultTemplate activeNavTitle="refract" Header={Header} Bottom={Bottom}>
      <Box sx={{ width: '100%' }}>
        <TabContext value={tabValue}>
          <Box sx={{ borderBottom: 1, borderColor: 'divider' }}>
            <TabList onChange={handleChangeTab} aria-label="Refracted posts tabs" classes={tabListClasses}>
              <Tab
                label={
                  <>
                    <span>あなたが</span>
                    <span>リフラクトした投稿</span>
                  </>
                }
                value="me"
                classes={tabClasses}
                wrapped
              />
              <Tab
                label={
                  <>
                    <span>フォロワーが</span>
                    <span>リフラクトした投稿</span>
                  </>
                }
                value="follower"
                classes={tabClasses}
                wrapped
              />
            </TabList>
          </Box>
          <TabPanel value="me" sx={{ padding: 0 }}>
            {loadingOfMe && <CircularProgress color="info" />}
            {errorOfMe && (
              <Box p={4} sx={{ textAlign: 'center' }}>
                {errorOfMe}
              </Box>
            )}
            {!loadingOfMe && !errorOfMe && refractsPeformedByMe.length === 0 && (
              <Box p={4} sx={{ textAlign: 'center', color: '#86868b' }}>
                投稿はありません。
              </Box>
            )}
            {refractsPeformedByMe.map((refract) => (
              <>
                <Box key={refract.refracted_at} className={classes.refractedAt}>
                  {formatTimeOfRfc3339ToDate(refract.refracted_at)}
                </Box>
                {refract.posts.map((post, index) => (
                  <PostBox
                    key={post.id}
                    postedBy={post.posted_by}
                    icon={post.icon_url}
                    userId={post.user_id}
                    userName={post.user_name}
                    postId={post.id}
                    content={post.content}
                    repliesCount={post.replies_count}
                    likesCount={post.likes_count}
                    likedByMe={post.liked_by_current_user}
                    postedAt={post.created_at}
                    locked={post.locked}
                    image={post.image_url}
                    needDividerOnDisplay={index !== refract.posts.length - 1}
                    status={post.status}
                  />
                ))}
              </>
            ))}
          </TabPanel>
          <TabPanel value="follower" sx={{ padding: 0 }}>
            {loadingOfFollower && <CircularProgress color="info" />}
            {errorOfFollower && (
              <Box p={4} sx={{ textAlign: 'center' }}>
                {errorOfFollower}
              </Box>
            )}
            {!loadingOfFollower && !errorOfFollower && refractsPeformedByFollower.length === 0 && (
              <Box p={4} sx={{ textAlign: 'center', color: '#86868b' }}>
                投稿はありません。
              </Box>
            )}
            {refractsPeformedByFollower.map((refract) => (
              <>
                <Box key={refract.refracted_at} className={classes.refractedAt}>
                  {formatTimeOfRfc3339ToDate(refract.refracted_at)}
                </Box>
                {refract.posts.map((post, index) => (
                  <PostBox
                    key={post.id}
                    postedBy={post.posted_by}
                    icon={post.icon_url}
                    userId={post.user_id}
                    userName={post.user_name}
                    postId={post.id}
                    content={post.content}
                    repliesCount={post.replies_count}
                    likesCount={post.likes_count}
                    likedByMe={post.liked_by_current_user}
                    postedAt={post.created_at}
                    locked={post.locked}
                    image={post.image_url}
                    needDividerOnDisplay={index !== refract.posts.length - 1}
                    status={post.status}
                  />
                ))}
              </>
            ))}
          </TabPanel>
        </TabContext>
      </Box>
    </DefaultTemplate>
  )
}

export default RefractedPosts
