/* eslint-disable @typescript-eslint/explicit-module-boundary-types */
// それらをActionsという名前をつけて一括で取得する
import initialState from '../store/initialState'; // 初期状態を取得
import * as Actions from './actions'; // actionsファイルにはuserに関連する複数のactionがある場合が多いが、

// eslint-disable-next-line import/prefer-default-export
export const UsersReducer = (
  state = initialState.users,
  action: { type: unknown; payload: string[] },
) => {
  // 第一引数には、現在のstoreのstate(現在の状態がないときは初期状態),第二引数には、actionがreturnした値(UIから取得したデータ)を設定
  switch (
    action.type // actionの種類に応じたstateの更新をしている
  ) {
    case Actions.SIGN_IN:
      // eslint-disable-next-line @typescript-eslint/no-unsafe-return
      return {
        ...state,
        ...action.payload, // スプレット構文で記述することで、stateとaction.payloadの間に重複キーがある場合は、action.payloadの
        // データが採用される=正しく更新される
      };
    default:
      return state;
  }
};
