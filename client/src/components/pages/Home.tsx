import { PostBox } from 'components/molecules';
import { RefractFuncDescriptionModal } from 'components/organisms';
import { DefaultTemplate } from 'components/templates';
import { useEffect, VFC } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { getPostsOfMeAndFollower } from 'reducks/posts/operations';
import { getPosts } from 'reducks/posts/selectors';

import { Box } from '@mui/material';

import { PostsOfMeAndFollower } from '../../reducks/posts/types';

const Home: VFC = () => {
  const dispatch = useDispatch()
  const selector = useSelector((state: { posts: Array<PostsOfMeAndFollower> }) => state)

  const posts = getPosts(selector)

  useEffect(() => {
    dispatch(getPostsOfMeAndFollower())
  }, [dispatch])

  return (
    <DefaultTemplate title="ホーム" activeNavTitle="home">
      {posts.length > 0 &&
        posts.map((post) => (
          <PostBox
            type={post.postedBy}
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
          />
        ))}
      <RefractFuncDescriptionModal type="text" />
      <Box sx={{ padding: '64px 0 120px 0', textAlign: 'center', fontSize: 14, color: '#86868b' }}>
        投稿は以上ですべてです。
      </Box>
    </DefaultTemplate>
  )
}
export default Home
