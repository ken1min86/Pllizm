import { useState } from 'react';
import { useSelector } from 'react-redux';
import { getUser } from 'reducks/users/selectors';
import { axiosBase } from 'util/api';
import { ErrorStatus } from 'util/types/common';
import {
    RefractPerformedByFollower, RefractPerformedByMe, ResponstOfRefractsPerformedByFollower,
    ResponstOfRefractsPerformedByMe
} from 'util/types/hooks/posts';
import { RequestHeaders } from 'util/types/hooks/users';
import { Users } from 'util/types/redux/users';

const useRefracts = () => {
  const selector = useSelector((state: { users: Users }) => state)

  const [refractsPeformedByMe, setRefractsPeformedByMe] = useState<Array<RefractPerformedByMe>>([])
  const [loadingOfMe, setLoadingOfMe] = useState(false)
  const [errorOfMe, setErrorOfMe] = useState('')

  const [refractsPeformedByFollower, setRefractsPeformedByFollower] = useState<Array<RefractPerformedByFollower>>([])
  const [loadingOfFollower, setLoadingOfFollower] = useState(false)
  const [errorOfFollower, setErrorOfFollower] = useState('')

  const loginUser = getUser(selector)
  const requestHeaders: RequestHeaders = {
    'access-token': loginUser.accessToken,
    client: loginUser.client,
    uid: loginUser.uid,
  }

  const getRefractsPerformedByMe = () => {
    setRefractsPeformedByMe([])
    setLoadingOfMe(true)
    setErrorOfMe('')
    axiosBase
      .get<ResponstOfRefractsPerformedByMe>('v1/refracts/by_me', { headers: requestHeaders })
      .then((response) => {
        setRefractsPeformedByMe(response.data.refracts)
      })
      .catch((error: ErrorStatus) => {
        const { status } = error.response
        if (String(status).indexOf('5') === 0) {
          setErrorOfMe('接続が失われました。確認してからやりなおしてください。')
        } else {
          setErrorOfMe(
            '予期せぬエラーが発生しました。オフラインでないか確認し、それでもエラーが発生する場合はお問い合わせフォームにて問い合わせ下さい。',
          )
        }
      })
      .finally(() => {
        setLoadingOfMe(false)
      })
  }

  const getRefractsPerformedByFollower = () => {
    setRefractsPeformedByFollower([])
    setLoadingOfFollower(true)
    setErrorOfFollower('')
    axiosBase
      .get<ResponstOfRefractsPerformedByFollower>('v1/refracts/by_followers', { headers: requestHeaders })
      .then((response) => {
        setRefractsPeformedByFollower(response.data.refracts)
      })
      .catch((error: ErrorStatus) => {
        const { status } = error.response
        if (String(status).indexOf('5') === 0) {
          setErrorOfFollower('接続が失われました。確認してからやりなおしてください。')
        } else {
          setErrorOfFollower(
            '予期せぬエラーが発生しました。オフラインでないか確認し、それでもエラーが発生する場合はお問い合わせフォームにて問い合わせ下さい。',
          )
        }
      })
      .finally(() => {
        setLoadingOfFollower(false)
      })
  }

  return {
    getRefractsPerformedByMe,
    getRefractsPerformedByFollower,
    refractsPeformedByMe,
    refractsPeformedByFollower,
    loadingOfMe,
    loadingOfFollower,
    errorOfMe,
    errorOfFollower,
  }
}

export default useRefracts
