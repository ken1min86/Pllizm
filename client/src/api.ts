import axios from 'axios';

// eslint-disable-next-line import/prefer-default-export
export const axiosBase = axios.create({
  // eslint-disable-next-line @typescript-eslint/restrict-template-expressions
  baseURL: `${process.env.REACT_APP_SERVER_URL}`,
  headers: { 'Content-Type': 'application/json' },
  responseType: 'json',
})
