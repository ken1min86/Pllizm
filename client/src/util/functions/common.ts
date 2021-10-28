import Cookies from 'js-cookie';
import { RequestHeadersForAuthentication } from 'util/types/common';
import { PostInThread, Threads } from 'util/types/redux/threads';
import { ListenAuthStateRequest, UsersOfGetState } from 'util/types/redux/users';

export const isValidEmailFormat = (email: string): boolean => {
  const regex = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/

  return regex.test(email)
}

export const createRequestHeaderUsingCookie = (): ListenAuthStateRequest => {
  const accessTokenInCookie = Cookies.get('access-token')
  const clientInCookie = Cookies.get('client')
  const uidInCookie = Cookies.get('uid')

  const requestHeaders: ListenAuthStateRequest = {
    'access-token': accessTokenInCookie,
    client: clientInCookie,
    uid: uidInCookie,
  }

  return requestHeaders
}

export const createTimeToDisplay = (postedAt: string): string => {
  const postedAtInJapan = new Date(Date.parse(postedAt))
  const now = new Date()
  const diffMs = now.getTime() - postedAtInJapan.getTime()
  const diffMinute = Math.floor(diffMs / 1000 / 60)
  const diffHour = Math.floor(diffMinute / 60)
  let timeToDisplay
  if (diffMinute < 60) {
    timeToDisplay = `${diffMinute}分前`
  } else if (diffHour < 24) {
    timeToDisplay = `${diffHour}時間前`
  } else if (postedAtInJapan.getFullYear() < now.getFullYear()) {
    const year = postedAtInJapan.getFullYear()
    const month = postedAtInJapan.getMonth() + 1
    const date = postedAtInJapan.getDate()
    timeToDisplay = `${year}年${month}月${date}日`
  } else {
    const month = postedAtInJapan.getMonth() + 1
    const date = postedAtInJapan.getDate()
    timeToDisplay = `${month}月${date}日`
  }

  return timeToDisplay
}

export const formatTimeOfRfc3339ToDate = (timeOfRfc3339: string): string => {
  const timeInJapan = new Date(Date.parse(timeOfRfc3339))
  const year = timeInJapan.getFullYear()
  const month = timeInJapan.getMonth() + 1
  const date = timeInJapan.getDate()

  return `${year}年${month}月${date}日`
}

export const createRequestHeader = (getState: UsersOfGetState): RequestHeadersForAuthentication => {
  const { uid, accessToken, client } = getState().users
  const requestHeaders: RequestHeadersForAuthentication = {
    'access-token': accessToken,
    client,
    uid,
  }

  return requestHeaders
}

export const containDisplayablePosts = (thread: Threads): boolean => {
  let hasAnyDisplayablePost = false

  hasAnyDisplayablePost = hasAnyDisplayablePost || thread.parent?.status === 'exist'
  hasAnyDisplayablePost = hasAnyDisplayablePost || thread.current.status === 'exist'

  if (!hasAnyDisplayablePost && thread.children) {
    for (let i = 0; i < thread.children.length; i += 1) {
      if (thread.children[i].status === 'exist') {
        hasAnyDisplayablePost = true
        break
      }
    }
  }

  return hasAnyDisplayablePost
}

export const containDisplayableChild = (children?: Array<PostInThread>): boolean => {
  let hasAnyDisplayableChild = false
  if (children) {
    for (let i = 0; i < children.length; i += 1) {
      if (children[i].status === 'exist') {
        hasAnyDisplayableChild = true
        break
      }
    }
  }

  return hasAnyDisplayableChild
}
