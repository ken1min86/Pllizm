import { useEffect, useState, VFC } from 'react';
import { useSelector } from 'react-redux';
import { getUser } from 'reducks/users/selectors';
import { axiosBase } from 'util/api';
import { RequestHeaders } from 'util/types/hooks/users';
import { Users } from 'util/types/redux/users';

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
  initialStatus: 'following' | 'requestingByMe' | 'requestedToMe' | 'default'
}

const FollowRelatedButton: VFC<Props> = ({ userId, initialStatus }) => {
  const classes = useStyles()
  const selector = useSelector((state: { users: Users }) => state)

  const [status, setStatus] = useState<'following' | 'requestingByMe' | 'requestedToMe' | 'default'>(initialStatus)

  const loginUser = getUser(selector)
  const requestHeaders: RequestHeaders = {
    'access-token': loginUser.accessToken,
    client: loginUser.client,
    uid: loginUser.uid,
  }

  useEffect(() => {
    setStatus(initialStatus)
  }, [initialStatus])

  const handleClickToFollow = () => {
    void axiosBase
      .post('v1/follow_requests/create', { request_to: `${userId}` }, { headers: requestHeaders })
      .then(() => {
        setStatus('requestingByMe')
      })
  }

  const handleClickToUnfollow = () => {
    void axiosBase.delete(`v1/followers/${userId}`, { headers: requestHeaders }).then(() => {
      setStatus('default')
    })
  }

  const handleClickToAcceptFollowRequest = () => {
    void axiosBase
      .post('v1/follow_requests/accept', { follow_to: `${userId}` }, { headers: requestHeaders })
      .then(() => {
        setStatus('following')
      })
  }

  const handleClickToRefuseFollowRequest = () => {
    void axiosBase
      .delete('v1/follow_requests/refuse', { params: { requested_by: `${userId}` }, headers: requestHeaders })
      .then(() => {
        setStatus('default')
      })
  }

  const handleClickToCancelFollowRequest = () => {
    void axiosBase
      .delete('v1/follow_requests/outgoing', { params: { request_to: `${userId}` }, headers: requestHeaders })
      .then(() => {
        setStatus('default')
      })
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
