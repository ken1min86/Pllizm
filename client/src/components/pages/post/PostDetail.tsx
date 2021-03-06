import { BottomNavigationBar, PostBox } from 'components/molecules';
import { HeaderWithTitleAndDrawer } from 'components/organisms';
import { DefaultTemplate } from 'components/templates';
import { useEffect, useState, VFC } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useParams } from 'react-router';
import { getThread } from 'reducks/threads/operations';
import { getThreadPosts } from 'reducks/threads/selectors';
import { containDisplayableChild, containDisplayablePosts } from 'util/functions/common';
import { Threads } from 'util/types/redux/threads';

import { Box, Hidden } from '@mui/material';

const PostDetail: VFC = () => {
  document.title = '投稿詳細 / Pllizm'

  const dispatch = useDispatch()
  const selector = useSelector((state: { threads: Threads }) => state)

  const params: { id: string } = useParams()
  const paramsId = params.id

  const [thread, setThread] = useState<Threads>(getThreadPosts(selector))

  const hasAnyDisplayablePost = containDisplayablePosts(thread)
  const hasAnyDisplayableChild = containDisplayableChild(thread.children)

  useEffect(() => {
    dispatch(getThread(paramsId))
  }, [dispatch, paramsId])

  useEffect(() => {
    setThread(getThreadPosts(selector))
  }, [selector])

  const Header = <HeaderWithTitleAndDrawer title="投稿" />
  const Bottom = (
    <Hidden smUp>
      <BottomNavigationBar activeNav="none" />
    </Hidden>
  )

  return (
    <DefaultTemplate activeNavTitle="none" Header={Header} Bottom={Bottom}>
      {hasAnyDisplayablePost && thread.parent && thread.parent.status !== 'not_exist' && (
        <PostBox
          key={thread.parent.id}
          postedBy={thread.parent.postedBy}
          icon={thread.parent.iconUrl}
          userId={thread.parent.userId}
          userName={thread.parent.userName}
          postId={thread.parent.id}
          content={thread.parent.content}
          repliesCount={thread.parent.repliesCount}
          likesCount={thread.parent.likesCount}
          likedByMe={thread.parent.likedByCurrentUser}
          postedAt={thread.parent.createdAt}
          locked={thread.parent.locked}
          image={thread.parent.imageUrl}
          needDividerOnDisplay={thread.current.status !== 'not_exist'}
          status={thread.parent.status}
        />
      )}
      {hasAnyDisplayablePost && thread.current.status !== 'not_exist' && (
        <PostBox
          key={thread.current.id}
          postedBy={thread.current.postedBy}
          icon={thread.current.iconUrl}
          userId={thread.current.userId}
          userName={thread.current.userName}
          postId={thread.current.id}
          content={thread.current.content}
          repliesCount={thread.current.repliesCount}
          likesCount={thread.current.likesCount}
          likedByMe={thread.current.likedByCurrentUser}
          postedAt={thread.current.createdAt}
          locked={thread.current.locked}
          image={thread.current.imageUrl}
          needDividerOnDisplay={hasAnyDisplayableChild}
          status={thread.current.status}
        />
      )}
      {hasAnyDisplayablePost &&
        thread.children &&
        thread.children.length > 0 &&
        thread.children.map(
          (child) =>
            child.status !== 'not_exist' && (
              <PostBox
                key={child.id}
                postedBy={child.postedBy}
                icon={child.iconUrl}
                userId={child.userId}
                userName={child.userName}
                postId={child.id}
                content={child.content}
                repliesCount={child.repliesCount}
                likesCount={child.likesCount}
                likedByMe={child.likedByCurrentUser}
                postedAt={child.createdAt}
                locked={child.locked}
                image={child.imageUrl}
                status={child.status}
              />
            ),
        )}
      {!hasAnyDisplayablePost && <Box sx={{ textAlign: 'center', marginTop: 16 }}>このページは存在しません。</Box>}
    </DefaultTemplate>
  )
}

export default PostDetail
