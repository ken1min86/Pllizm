export const SIGN_IN = 'SIGN_IN'; // reducer用にexport
// eslint-disable-next-line @typescript-eslint/explicit-module-boundary-types
export const signInAction = () =>
  // この関数がユーザーによるUIの操作によって呼び出されるイメージ.
  // 引数は操作内容によってない場合もある;

  ({
    // ※actionsは常にプレーンなオブジェクトを返す(actionsでは純粋なデータだけを扱いたいから)
    type: 'SIGN_IN', // actionの種類(storeに変更を与える処理の種類), 上の定数と同じ名前
    payload: {
      // reducerに渡したいデータの塊
      isSignIn: true,
      // uid: userState.id,
      // username: userState.username,
    },
  });
