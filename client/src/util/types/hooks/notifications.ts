export type Notofication = {
  action: 'like' | 'reply' | 'request' | 'accept' | 'refract'
  // eslint-disable-next-line camelcase
  user_id: string
  // eslint-disable-next-line camelcase
  user_name: string
  // eslint-disable-next-line camelcase
  user_icon_url: string
  checked: boolean
  // eslint-disable-next-line camelcase
  notified_at: string
  post: {
    id: string
    content: string
  }
}

// ***************************************
// Responses
export type ResponseOfNotifications = {
  notifications: Array<Notofication>
}
