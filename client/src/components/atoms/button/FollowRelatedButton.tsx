import useChangeRelationship from 'hooks/useChangeRelationship';
import { useEffect, VFC } from 'react';
import { UsersRelationship } from 'util/types/hooks/users';

import { Box } from '@mui/material';
import { createStyles, makeStyles } from '@mui/styles';

// eslint-disable-next-line import/no-useless-path-segments
import { ContainedRoundedCornerButton } from '../';

const useStyles = makeStyles(() =>
  createStyles({
    buttonWhenNotHover: {}, // buttonHoverContainerでスタイルを当てるために作成。削除しないこと。
    buttonWhenHover: {
      minWidth: 152,
    },
    buttonHoverContainer: {
      '&:hover': {
        '& $buttonWhenNotHover': {
          display: 'none',
        },
        '& $buttonWhenHover': {
          display: 'block',
        },
      },
      '& $buttonWhenHover': {
        display: 'none',
      },
    },
  }),
)

type Props = {
  userId: string
  initialStatus: UsersRelationship
}

const FollowRelatedButton: VFC<Props> = ({ userId, initialStatus }) => {
  const classes = useStyles()

  const {
    requestFollowing,
    unfollow,
    acceptFollowRequest,
    refuseFollowRequest,
    cancelFollowRequest,
    status,
    setStatus,
  } = useChangeRelationship(initialStatus)

  useEffect(() => {
    setStatus(initialStatus)
  }, [initialStatus, setStatus])

  const handleClickToFollow = () => {
    requestFollowing(userId)
  }

  const handleClickToUnfollow = () => {
    unfollow(userId)
  }

  const handleClickToAcceptFollowRequest = () => {
    acceptFollowRequest(userId)
  }

  const handleClickToRefuseFollowRequest = () => {
    refuseFollowRequest(userId)
  }

  const handleClickToCancelFollowRequest = () => {
    cancelFollowRequest(userId)
  }

  const handleClickDummy = () => {
    console.log('')
  }

  return (
    <>
      {status === 'default' && (
        <ContainedRoundedCornerButton label="フォローする" backgroundColor="#2699fb" onClick={handleClickToFollow} />
      )}
      {status === 'following' && (
        <Box className={classes.buttonHoverContainer}>
          <Box className={classes.buttonWhenNotHover}>
            <ContainedRoundedCornerButton label="フォロー中" backgroundColor="#333333" onClick={handleClickDummy} />
          </Box>
          <Box className={classes.buttonWhenHover}>
            <ContainedRoundedCornerButton
              label="フォロー解除"
              backgroundColor="#e0245e"
              onClick={handleClickToUnfollow}
            />
          </Box>
        </Box>
      )}
      {status === 'requestedToMe' && (
        <Box sx={{ display: 'flex', flexDirection: 'column', gap: 1 }}>
          <ContainedRoundedCornerButton
            label="フォローを許可する"
            backgroundColor="#2699fb"
            onClick={handleClickToAcceptFollowRequest}
          />
          <ContainedRoundedCornerButton
            label="フォローを許可しない"
            backgroundColor="#e0245e"
            onClick={handleClickToRefuseFollowRequest}
          />
        </Box>
      )}
      {status === 'requestingByMe' && (
        <Box className={classes.buttonHoverContainer}>
          <Box className={classes.buttonWhenNotHover}>
            <ContainedRoundedCornerButton
              label="フォローリクエスト中"
              backgroundColor="#333333"
              onClick={handleClickDummy}
            />
          </Box>
          <Box className={classes.buttonWhenHover}>
            <ContainedRoundedCornerButton
              label="キャンセル"
              backgroundColor="#e0245e"
              onClick={handleClickToCancelFollowRequest}
            />
          </Box>
        </Box>
      )}
    </>
  )
}

export default FollowRelatedButton
