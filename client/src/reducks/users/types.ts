export type SignUpAction = (userState: {
  uid: string
  accessToken: string
  client: string
  userId: string
  userName: string
}) => {
  type: string
  payload: {
    isSignedIn: true
    uid: string
    accessToken: string
    client: string
    userId: string
    userName: string
  }
}

export type SignInAction = (userState: {
  uid: string
  accessToken: string
  client: string
  userId: string
  userName: string
}) => {
  type: string
  payload: {
    isSignedIn: true
    uid: string
    accessToken: string
    client: string
    userId: string
    userName: string
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
    }
  },
) => {
  isSignedIn: boolean
  uid: string
  accessToken: string
  client: string
  userId: string
  userName: string
}

export type Users = {
  isSignedIn: boolean
  uid: string
  accessToken: string
  client: string
  userId: string
  userName: string
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
