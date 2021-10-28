export type Weaken<T, K extends keyof T> = {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  [P in keyof T]: P extends K ? any : T[P]
}

export type ErrorStatus = {
  response: {
    status: number
    statusText: string
  }
}

export type RequestHeadersForAuthentication = {
  // eslint-disable-next-line camelcase
  'access-token': string
  client: string
  uid: string
}
