import { RequestHeadersForAuthentication, UsersOfGetState } from 'reducks/users/types';

export const isValidEmailFormat = (email: string): boolean => {
  const regex = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/

  return regex.test(email)
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

export const createRequestHeader = (getState: UsersOfGetState) => {
  const { uid, accessToken, client } = getState().users
  const requestHeaders: RequestHeadersForAuthentication = {
    'access-token': accessToken,
    client,
    uid,
  }

  return requestHeaders
}
