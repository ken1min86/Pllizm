export type SignUpAction = (userState: {
  uid: string
  accessToken: string
  client: string
  userId: string
  userName: string
  icon: string
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
  }
}

export type SignInAction = (userState: {
  uid: string
  accessToken: string
  client: string
  userId: string
  userName: string
  icon: string
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
  }
}

export type Reducer = (
  state: {
    isSignedIn: boolean
    uid: string
    accessToken: string
    client: string
    userId: string
    userName: string
    icon: string
  },
  action: {
    type: string
    payload: {
      isSignedIn?: boolean
      uid?: string
      accessToken?: string
      client?: string
      userId?: string
      userName?: string
      icon?: string
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
}

export type Users = {
  isSignedIn: boolean
  uid: string
  accessToken: string
  client: string
  userId: string
  userName: string
  icon: string
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

export type RequestHeadersForAuthentication = {
  // eslint-disable-next-line camelcase
  'access-token': string
  client: string
  uid: string
}
