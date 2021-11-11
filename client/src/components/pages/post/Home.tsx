import { PostBox } from 'components/molecules';
import { HeaderWithTitleAndDrawer } from 'components/organisms';
import { DefaultTemplate } from 'components/templates';
import { useEffect, useState, VFC } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { getPostsOfMeAndFollower } from 'reducks/posts/operations';
import { getPosts } from 'reducks/posts/selectors';

import { Box, Hidden } from '@mui/material';

import { PostsOfMeAndFollower } from '../../../util/types/redux/posts';
import { BottomNavigationBar } from '../../molecules';

const Home: VFC = () => {
  document.title = 'ホーム / Pllizm'

  const dispatch = useDispatch()
  const selector = useSelector((state: { posts: Array<PostsOfMeAndFollower> }) => state)

  const [posts, setPosts] = useState(getPosts(selector))

  useEffect(() => {
    dispatch(getPostsOfMeAndFollower())
  }, [dispatch])

  useEffect(() => {
    setPosts(getPosts(selector))
  }, [selector])

  const Header = <HeaderWithTitleAndDrawer title="ホーム" />
  const Bottom = (
    <Hidden smUp>
      <BottomNavigationBar activeNav="home" />
    </Hidden>
  )

  return (
    <DefaultTemplate activeNavTitle="home" Header={Header} Bottom={Bottom}>
      {posts.length > 0 &&
        posts.map((post, index) => (
          <>
            <PostBox
              key={post.id}
              postedBy={post.postedBy}
              icon={post.iconUrl}
              userId={post.userId}
              userName={post.userName}
              postId={post.id}
              content={post.content}
              repliesCount={post.repliesCount}
              likesCount={post.likesCount}
              likedByMe={post.likedByCurrentUser}
              postedAt={post.createdAt}
              locked={post.locked}
              image={post.imageUrl}
              status="exist"
            />
            {index === posts.length - 1 && (
              <Box sx={{ padding: '64px 0 120px 0', textAlign: 'center', fontSize: 14, color: '#86868b' }}>
                投稿は以上ですべてです。
              </Box>
            )}
          </>
        ))}
    </DefaultTemplate>
  )
}
export default Home
