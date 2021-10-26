import { AccountDrawer, PerformRefractModal, SkipRefractModal } from 'components/organisms';
import { DefaultTemplate } from 'components/templates';
import { useEffect, useState, VFC } from 'react';
import { Link } from 'react-router-dom';

import { Avatar, Box, Divider, Hidden, LinearProgress, Radio, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

import useRefractCandidates from '../../hooks/useRefractCandidates';
import { RefractFuncDescriptionModal } from '../organisms';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    title: {
      color: theme.palette.primary.main,
      fontSize: 22,
      [theme.breakpoints.up('sm')]: {
        marginLeft: 16,
      },
    },
    postIcon: {
      marginRight: 12,
      [theme.breakpoints.up('sm')]: {
        width: 40,
        height: 40,
      },
      [theme.breakpoints.down('sm')]: {
        width: 36,
        height: 36,
      },
    },
    postContent: {
      marginRight: 24,
      [theme.breakpoints.down('sm')]: {
        fontSize: 13,
      },
    },
    detailLink: {
      color: theme.palette.info.main,
      margin: '0 16px 0 auto',
      [theme.breakpoints.up('sm')]: {
        fontSize: 14,
      },
      [theme.breakpoints.down('sm')]: {
        fontSize: 12,
      },
    },
    userName: {
      marginRight: 8,
      [theme.breakpoints.down('sm')]: {
        fontSize: 13,
      },
    },
    userId: {
      color: theme.palette.text.disabled,
      [theme.breakpoints.up('sm')]: {
        fontSize: 14,
      },
      [theme.breakpoints.down('sm')]: {
        fontSize: 13,
      },
    },
    bottomContainer: {
      backgroundColor: '#333333',
      padding: 16,
      display: 'flex',
      gap: 16,
      justifyContent: 'space-evenly',
      width: '100%',
      [theme.breakpoints.up('sm')]: {
        height: 80,
      },
      [theme.breakpoints.down('sm')]: {
        height: 100,
      },
    },
    modalButton: {
      [theme.breakpoints.up('sm')]: {
        width: '30%',
      },
      [theme.breakpoints.down('sm')]: {
        width: '45%',
      },
    },
  }),
)

const radioButtonUseStyles = makeStyles((theme: Theme) =>
  createStyles({
    root: {
      color: theme.palette.text.disabled,
      padding: 0,
      marginBottom: 'auto',
      '&$checked': {
        color: theme.palette.info.main,
      },
    },
    checked: {},
  }),
)

const RefractCandidates: VFC = () => {
  const classes = useStyles()
  const radioButtonClasses = radioButtonUseStyles()

  const [selectedValue, setSelectedValue] = useState('')

  const { getRefractCandidates, posts, loading, errorMessage } = useRefractCandidates()

  useEffect(() => {
    getRefractCandidates()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  const handleChangeRadioButton = (event: React.ChangeEvent<HTMLInputElement>) => {
    setSelectedValue(event.target.value)
  }

  const Header = (
    <Box sx={{ width: '100%', display: 'flex', alignItems: 'center' }}>
      <Hidden smUp>
        <AccountDrawer />
      </Hidden>
      <h1 className={classes.title}>refract</h1>
      <Box mr={2} sx={{ marginLeft: 'auto' }}>
        <RefractFuncDescriptionModal type="questionButton" />
      </Box>
    </Box>
  )

  const Bottom = (
    <Box className={classes.bottomContainer}>
      <Box className={classes.modalButton}>
        <SkipRefractModal />
      </Box>
      <Box className={classes.modalButton}>
        <PerformRefractModal refractCandidateId={selectedValue} />
      </Box>
    </Box>
  )

  return (
    <DefaultTemplate activeNavTitle="refract" Header={Header} Bottom={Bottom}>
      {loading && <LinearProgress color="info" />}
      {errorMessage && <Box p={3}>{errorMessage}</Box>}
      <Box pt={3} pb={13} sx={{ width: '95%', margin: '0 auto' }}>
        {posts.length > 0 &&
          posts.map((post) => (
            <Box mb={2} sx={{ border: '1px solid #86868b', borderRadius: 4, width: '100%' }} key={post.id}>
              <Box ml={2} mt={2} mr={2} mb={3} sx={{ display: 'flex' }}>
                <Avatar className={classes.postIcon} alt="Posted user icon" src={post.icon_url} />
                <Box mt={-0.5} sx={{ display: 'flex', flexDirection: 'column' }}>
                  <Box>
                    {post.user_name && <span className={classes.userName}>{post.user_name}</span>}
                    {post.user_id && <span className={classes.userId}>@{post.user_id}</span>}
                  </Box>
                  <span className={classes.postContent}>{post.content}</span>
                </Box>
                <Radio
                  sx={{ marginLeft: 'auto' }}
                  checked={selectedValue === post.id}
                  onChange={handleChangeRadioButton}
                  value={post.id}
                  name="radio-buttons"
                  inputProps={{ 'aria-label': 'Select post to refract' }}
                  classes={radioButtonClasses}
                />
              </Box>
              <Divider />
              <Box sx={{ height: 40, display: 'flex', alignItems: 'center' }}>
                <Link className={classes.detailLink} to={`/saturday/refracts/candidates/${post.id}`}>
                  詳細を表示
                </Link>
              </Box>
            </Box>
          ))}
      </Box>
    </DefaultTemplate>
  )
}

export default RefractCandidates
