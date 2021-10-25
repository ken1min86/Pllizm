import { HeaderWithBackAndTitle, PostBox } from 'components/molecules';
import { DefaultTemplate } from 'components/templates';
import { useEffect, VFC } from 'react';
import { useParams } from 'react-router';

import { Box, LinearProgress } from '@mui/material';

import useRefractCandidatesThread from '../../hooks/useRefractCandidatesThread';

const RefractCandidateDetail: VFC = () => {
  const params: { id: string } = useParams()
  const paramsId = params.id

  const { getRefractCandidatesThread, posts, loading, errorMessage } = useRefractCandidatesThread(paramsId)

  useEffect(() => {
    getRefractCandidatesThread()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  const Header = <HeaderWithBackAndTitle title="詳細" />
  const Bottom = <></>

  return (
    <DefaultTemplate activeNavTitle="refract" Header={Header} Bottom={Bottom}>
      {loading && <LinearProgress color="info" />}
      {errorMessage && <Box p={3}>{errorMessage}</Box>}
      {posts.length > 0 &&
        posts.map((post, index) => (
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
            status="exist"
            needDividerOnDisplay={index !== posts.length - 1}
            disableAllOnClick
          />
        ))}
    </DefaultTemplate>
  )
}

export default RefractCandidateDetail
