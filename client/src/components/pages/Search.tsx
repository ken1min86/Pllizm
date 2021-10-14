import { axiosBase } from 'api';
import { AccountDrawer } from 'components/organisms';
import { DefaultTemplate } from 'components/templates';
import { push } from 'connected-react-router';
import { useEffect, useState, VFC } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { getUser } from 'reducks/users/selectors';
import { RequestHeadersForAuthentication } from 'reducks/users/types';

import SearchIcon from '@mui/icons-material/Search';
import { Avatar, Box, Divider, Hidden, InputAdornment, TextField, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

import { Users } from '../../reducks/users/types';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    input: {
      color: theme.palette.primary.light,
    },
    userName: {
      fontSize: 15,
      fontWeight: 'bold',
    },
    userId: {
      fontSize: 13,
      color: theme.palette.primary.main,
    },
  }),
)

type User = {
  // eslint-disable-next-line camelcase
  user_id: string
  // eslint-disable-next-line camelcase
  user_name: string
  // eslint-disable-next-line camelcase
  image_url: string
  bio: string
}

type Reponse = {
  users: Array<User>
}

const Search: VFC = () => {
  const classes = useStyles()
  const dispatch = useDispatch()
  const selector = useSelector((state: { users: Users }) => state)

  const [query, setQuery] = useState('')
  const [searchedUsers, setSearchedUsers] = useState<Array<User>>([])

  const handleChangeOfInput = (event: React.ChangeEvent<HTMLInputElement>) => {
    setQuery(event.target.value)
  }

  useEffect(() => {
    const searchUser = async (): Promise<void> => {
      if (!query) {
        setSearchedUsers([])

        return
      }

      const user = getUser(selector)
      const requestHeaders: RequestHeadersForAuthentication = {
        'access-token': user.accessToken,
        client: user.client,
        uid: user.uid,
      }

      await axiosBase
        .get<Reponse>(`/v1/search/users?q=${query}`, { headers: requestHeaders })
        .then((response) => {
          setSearchedUsers(response.data.users)
        })
        .catch((errors) => {
          console.log(errors)
        })
    }
    void searchUser()
  }, [query, selector])

  const returnHeaderFunc = () => (
    <>
      <Hidden smUp>
        <AccountDrawer />
      </Hidden>
      <TextField
        id="input-with-icon-textfield"
        InputProps={{
          startAdornment: (
            <InputAdornment position="start">
              <SearchIcon sx={{ color: '#86868B' }} />
            </InputAdornment>
          ),
          className: classes.input,
        }}
        variant="outlined"
        fullWidth
        sx={{
          width: '100%',
          margin: '0 16px',
          backgroundColor: 'rgba(123,123,123,0.4)',
          borderRadius: 1,
        }}
        size="small"
        color="info"
        onChange={handleChangeOfInput}
      />
    </>
  )

  return (
    <DefaultTemplate activeNavTitle="search" returnHeaderFunc={returnHeaderFunc}>
      <Box sx={{ width: '100%' }}>
        {searchedUsers.length > 0 &&
          searchedUsers.map((searchedUser) => (
            <div key={searchedUser.user_id}>
              <Box
                sx={{ backgroundColor: '#707070', color: '#fffffe', display: 'flex', padding: 1, width: '100%' }}
                onClick={() => {
                  dispatch(push(`/${searchedUser.user_id}`))
                }}
                component="button"
              >
                <Avatar alt="Searched user" src={searchedUser.image_url} sx={{ marginRight: 1 }} />
                <Box sx={{ display: 'flex', flexDirection: 'column' }}>
                  <span className={classes.userName}>{searchedUser.user_name}</span>
                  <span className={classes.userId}>@{searchedUser.user_id}</span>
                </Box>
              </Box>
              <Divider sx={{ backgroundColor: '#86868b' }} />
            </div>
          ))}
      </Box>
    </DefaultTemplate>
  )
}
export default Search
