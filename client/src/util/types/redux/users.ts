// ***************************************
// Actions
export type SignUpAction = (userState: {
  uid: string
  accessToken: string
  client: string
  userId: string
  userName: string
  icon: string
  needDescriptionAboutLock: boolean
}) => {
  type: string
  payload: {
    isSignedIn: true
    uid: string
    accessToken: string
    client: string
    userId: string
    userName: string
    icon: string
    needDescriptionAboutLock: boolean
  }
}

export type SignInAction = (userState: {
  uid: string
  accessToken: string
  client: string
  userId: string
  userName: string
  icon: string
  needDescriptionAboutLock: boolean
}) => {
  type: string
  payload: {
    isSignedIn: true
    uid: string
    accessToken: string
    client: string
    userId: string
    userName: string
    icon: string
    needDescriptionAboutLock: boolean
  }
}

export type SignOutAction = () => {
  type: string
  payload: {
    isSignedIn: false
    uid: null
    accessToken: null
    client: null
    userId: null
    userName: null
    icon: null
    hasRightToUsePllizm: true
  }
}

export type DisableLockDescriptionAction = (userState: { needDescriptionAboutLock: false }) => {
  type: string
  payload: {
    needDescriptionAboutLock: false
  }
}

export type GetStatusOfRightToUsePllizmAction = (userState: { hasRightToUsePllizm: boolean }) => {
  type: string
  payload: {
    hasRightToUsePllizm: boolean
  }
}

export type GetPerformedRefractAction = (userState: { performedRefract: boolean }) => {
  type: string
  payload: {
    performedRefract: boolean
  }
}

// ***************************************
// Reducers
export type Reducer = (
  state: {
    isSignedIn: boolean
    uid: string
    accessToken: string
    client: string
    userId: string
    userName: string
    icon: string
    needDescriptionAboutLock: boolean
    hasRightToUsePllizm: boolean
    performedRefract: boolean
  },
  action: {
    type: string
    payload: {
      isSignedIn: boolean
      uid?: string
      accessToken?: string
      client?: string
      userId?: string
      userName?: string
      icon?: string
      needDescriptionAboutLock: boolean
      hasRightToUsePllizm: boolean
      performedRefract: boolean
    }
  },
) => {
  isSignedIn: boolean
  uid: string
  accessToken: string
  client: string
  userId: string
  userName: string
  icon: string
  needDescriptionAboutLock: boolean
  hasRightToUsePllizm: boolean
}

// ***************************************
// Operatons & Selectors
export type Users = {
  isSignedIn: boolean
  uid: string
  accessToken: string
  client: string
  userId: string
  userName: string
  icon: string
  needDescriptionAboutLock: boolean
  hasRightToUsePllizm: boolean
  performedRefract: boolean
}

export type UsersOfGetState = () => {
  users: Users
}

export type SignUpRequest = {
  email: string
  password: string
  // eslint-disable-next-line camelcase
  password_confirmation: string
}

export type SignUpResponse = {
  data: {
    email: string
    uid: string
    username: string
    userid: string
    image: { url: string }
    // eslint-disable-next-line camelcase
    need_description_about_lock: boolean
  }
}

export type ListenAuthStateRequest = {
  // eslint-disable-next-line camelcase
  'access-token': string | undefined
  client: string | undefined
  uid: string | undefined
}

export type SignInRequest = {
  email: string
  password: string
}

export type GetStatusOfRightToUsePllizmResponse = {
  // eslint-disable-next-line camelcase
  has_right_to_use_pllizm: boolean
}

export type GetPerformedRefractResponse = {
  performed: boolean
}
