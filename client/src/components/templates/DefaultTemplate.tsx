import { LogoLink } from 'components/atoms';
import { BottomNavigationBar, IconWithTextLink } from 'components/molecules';
import { AccountDrawer, AccountLogoutPopover } from 'components/organisms';
import { push } from 'connected-react-router';
import { FC } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Link } from 'react-router-dom';
import { getUserId } from 'reducks/users/selectors';
import { Users } from 'reducks/users/types';

import HomeRoundedIcon from '@mui/icons-material/HomeRounded';
import NotificationsNoneRoundedIcon from '@mui/icons-material/NotificationsNoneRounded';
import PersonIcon from '@mui/icons-material/Person';
import SearchIcon from '@mui/icons-material/Search';
import SettingsIcon from '@mui/icons-material/Settings';
import { Box, Hidden, Theme } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

import Logo from '../../assets/HeaderLogo.png';
import LogoIconActive from '../../assets/LogoIconActive1.png';
import LogoIconInactive from '../../assets/LogoIconInactive1.png';

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    header: {
      position: 'fixed',
      top: 0,
      zIndex: 1,
      backgroundColor: '#333333',
      height: 49,
      display: 'flex',
      alignItems: 'center',
      [theme.breakpoints.up('sm')]: {
        width: '600px',
      },
      [theme.breakpoints.down('sm')]: {
        width: '100vw',
      },
    },
    img: {
      width: 28,
      position: 'absolute',
      display: 'block',
      left: 'calc( 50% - 14px )',
    },
    nav: {
      position: 'fixed',
      top: 8,
      display: 'flex',
      flexDirection: 'column',
      [theme.breakpoints.up('lg')]: {
        alignItems: 'flex-start',
      },
      [theme.breakpoints.down('lg')]: {
        alignItems: 'center',
      },
    },
    main: {
      marginTop: 49,
    },
    bottom: {
      order: 3,
      position: 'fixed',
      bottom: 24,
      [theme.breakpoints.up('lg')]: {
        width: 240,
      },
    },
    logoIcon: {
      width: 26.25,
    },
    container: {
      display: 'flex',
      minHeight: '100vh',
      [theme.breakpoints.up('lg')]: {
        width: '1200px',
        margin: '0 auto',
      },
      [theme.breakpoints.down('lg')]: {
        width: '100%',
      },
    },
    navContainer: {
      order: 1,
      flex: 1,
      display: 'flex',
      justifyContent: 'flex-end',
      [theme.breakpoints.up('lg')]: {
        marginRight: 40,
      },
      [theme.breakpoints.down('lg')]: {
        marginRight: 16,
        minWidth: 64,
      },
    },
    asideContainer: {
      order: 3,
      [theme.breakpoints.up('lg')]: {
        marginLeft: '24px',
        flex: 1,
      },
      [theme.breakpoints.down('lg')]: {
        flex: 1,
      },
    },
    mainContainer: {
      order: 2,
      [theme.breakpoints.up('sm')]: {
        borderRight: '1px solid #EEEEEE',
        borderLeft: '1px solid #EEEEEE',
        width: '600px',
      },
      [theme.breakpoints.down('sm')]: {
        minWidth: '100vw',
        width: '100%',
      },
    },
    footerText: {
      fontSize: 13,
      color: theme.palette.text.disabled,
      marginRight: 16,
    },
    title: {
      fontSize: 20,
      fontWeight: 'bold',
      marginLeft: 16,
      color: theme.palette.primary.light,
    },
    buttomNavContainer: {
      position: 'fixed',
      bottom: 0,
      width: '100%',
    },
  }),
)

type Props = {
  title: string
  activeNavTitle: 'home' | 'search' | 'notification' | 'refract' | 'profile' | 'settings'
}

const DefaultTemplate: FC<Props> = ({ children, title, activeNavTitle }) => {
  const classes = useStyles()
  const dispatch = useDispatch()
  const selector = useSelector((state: { users: Users }) => state)

  const userId = getUserId(selector)

  const isActiveOfHome = activeNavTitle === 'home'
  const isActiveOfSearch = activeNavTitle === 'search'
  const isActiveOfNotification = activeNavTitle === 'notification'
  const isActiveOfRefract = activeNavTitle === 'refract'
  const isActiveOfProfile = activeNavTitle === 'profile'
  const isActiveOfSettings = activeNavTitle === 'settings'

  const handleOnClickToHome = () => {
    dispatch(push('/home'))
  }

  return (
    <Box sx={{ backgroundColor: '#f9f4ef', minHeight: '100vh' }}>
      <Box className={classes.container}>
        <Box className={classes.mainContainer}>
          <header className={classes.header}>
            <Hidden smDown>
              <h1 className={classes.title}>{title}</h1>
            </Hidden>
            <Hidden smUp>
              <AccountDrawer />
              <img className={classes.img} src={Logo} alt="ロゴ" />
            </Hidden>
          </header>
          <main className={classes.main}>{children}</main>
          <Hidden smUp>
            <Box className={classes.buttomNavContainer}>
              <BottomNavigationBar activeNav={activeNavTitle} />
            </Box>
          </Hidden>
        </Box>
        <Hidden smDown>
          <Box className={classes.navContainer}>
            <nav className={classes.nav}>
              <Box mb={1}>
                <LogoLink width={30} onClick={handleOnClickToHome} />
              </Box>
              <Box mb={1}>
                <IconWithTextLink title="ホーム" path="/home" isActive={isActiveOfHome}>
                  <HomeRoundedIcon sx={{ fontSize: 26.25 }} />
                </IconWithTextLink>
              </Box>
              <Box mb={1}>
                <IconWithTextLink title="検索" path="/search" isActive={isActiveOfSearch}>
                  <SearchIcon sx={{ fontSize: 26.25 }} />
                </IconWithTextLink>
              </Box>
              <Box mb={1}>
                <IconWithTextLink title="通知" path="/notifications" isActive={isActiveOfNotification}>
                  <NotificationsNoneRoundedIcon sx={{ fontSize: 26.25 }} />
                </IconWithTextLink>
              </Box>
              <Box mb={1}>
                <IconWithTextLink title="リフラクト" path={`/${userId}/reflected_posts`} isActive={isActiveOfRefract}>
                  {isActiveOfRefract && <img src={LogoIconActive} alt="ロゴアイコン" className={classes.logoIcon} />}
                  {!isActiveOfRefract && <img src={LogoIconInactive} alt="ロゴアイコン" className={classes.logoIcon} />}
                </IconWithTextLink>
              </Box>
              <Box mb={1}>
                <IconWithTextLink title="プロフィール" path={`/${userId}`} isActive={isActiveOfProfile}>
                  <PersonIcon sx={{ fontSize: 26.25 }} />
                </IconWithTextLink>
              </Box>
              <Box mb={1}>
                <IconWithTextLink title="設定" path="/settings/account" isActive={isActiveOfSettings}>
                  <SettingsIcon sx={{ fontSize: 26.25 }} />
                </IconWithTextLink>
              </Box>
              <Hidden lgUp>
                <Box className={classes.bottom}>
                  <AccountLogoutPopover userName="testName" userId="testId" icon={Logo} />
                </Box>
              </Hidden>
            </nav>
          </Box>
        </Hidden>
        <Box className={classes.asideContainer}>
          <Hidden lgDown>
            <Box className={classes.bottom}>
              <AccountLogoutPopover userName="testName" userId="testId" icon={Logo} />
              <footer>
                <Box component="ul" display="flex" flexWrap="wrap" mt={3}>
                  <li className={classes.footerText}>お問い合わせ</li>
                  <li className={classes.footerText}>
                    <Link to="/help/terms_of_use" data-testid="terms-of-use-link">
                      利用規約
                    </Link>
                  </li>
                  <li className={classes.footerText}>
                    <Link to="/help/privacy_policy" data-testid="privacy-policy-link">
                      プライバシーポリシー
                    </Link>
                  </li>
                </Box>
                <small className={classes.footerText}>@2021 Plizm</small>
              </footer>
            </Box>
          </Hidden>
        </Box>
      </Box>
    </Box>
  )
}

export default DefaultTemplate