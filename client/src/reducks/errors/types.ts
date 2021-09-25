export type ErrorsAction = (errors: string[]) => {
  type: string
  payload: {
    list: string[]
  }
}
export type Reducer = (
  state: {
    list: string[]
  },
  action: {
    type: string
    payload: {
      list: string[]
    }
  },
) => {
  list: string[]
}

export type Errors = {
  list: string[]
}

export type ErrorsList = string[]
