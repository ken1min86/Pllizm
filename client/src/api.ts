import axios from 'axios'

const axiosBase = axios.create({
  // eslint-disable-next-line @typescript-eslint/restrict-template-expressions
  baseURL: `${process.env.REACT_APP_SERVER_URL}`,
  headers: { 'Content-Type': 'application/json' },
  responseType: 'json',
})

export default axiosBase
