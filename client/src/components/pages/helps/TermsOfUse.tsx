import { VFC } from 'react';

import { Box, Container } from '@mui/material';
import createStyles from '@mui/styles/createStyles';
import makeStyles from '@mui/styles/makeStyles';

import { HelpContentItemTitle } from '../../atoms/index';
import { HelpContentTitleContainer } from '../../molecules/index';
import { Footer, HeaderWithTitleAndReturnArrow } from '../../organisms/index';

const useStyles = makeStyles((theme) =>
  createStyles({
    main: {
      paddingTop: '32px',
      paddingBottom: '32px',
      backgroundColor: theme.palette.primary.main,
      [theme.breakpoints.down('sm')]: {
        paddingTop: '24px',
        paddingBottom: '24px',
      },
    },
    container: {
      maxWidth: '810px',
      [theme.breakpoints.down('sm')]: {
        maxWidth: '330px',
      },
    },
    h1: {
      fontSize: '30px',
      marginBottom: '8px',
      [theme.breakpoints.down('sm')]: {
        fontSize: '24px',
        marginBottom: '8px',
      },
    },
    h2: {
      fontSize: '22px',
      marginBottom: '8px',
    },
    p: {
      fontSize: '16px',
      marginLeft: '24px',
      [theme.breakpoints.down('sm')]: {
        fontSize: '12px',
        marginLeft: '8px',
      },
    },
    ol: {
      listStyleType: 'decimal',
      listStylePosition: 'inside',
      marginLeft: '24px',
      marginBottom: '8px',
      fontSize: '16px',
      [theme.breakpoints.down('sm')]: {
        marginLeft: '8px',
        fontSize: '12px',
      },
    },
    li: {
      marginBottom: '8px',
    },
  }),
)

const TermsOfUse: VFC = () => {
  document.title = '利用規約 / Pllizm'
  const classes = useStyles()

  return (
    <>
      <header>
        <HeaderWithTitleAndReturnArrow title="利用規約" />
      </header>
      <main className={classes.main}>
        <Container className={classes.container}>
          <HelpContentTitleContainer
            title="利用規約"
            description="この利用規約（以下，「本規約」といいます。）は，中村謙一（以下，「当サービス提供者」といいます。）がこのウェブサイト上で提供するサービス（以下，「本サービス」といいます。）の利用条件を定めるものです。登録ユーザーの皆さま（以下，「ユーザー」といいます。）には，本規約に従って，本サービスをご利用いただきます。"
          />
          <Box mb={3}>
            <HelpContentItemTitle itemTitle="第1条（適用）" />
            <ol className={classes.ol}>
              <li className={classes.li}>
                本規約は，ユーザーと当サービス提供者との間の本サービスの利用に関わる一切の関係に適用されるものとします。
              </li>
              <li className={classes.li}>
                当サービス提供者は本サービスに関し，本規約のほか，ご利用にあたってのルール等，各種の定め（以下，「個別規定」といいます。）をすることがあります。これら個別規定はその名称のいかんに関わらず，本規約の一部を構成するものとします。
              </li>
              <li className={classes.li}>
                本規約の規定が前条の個別規定の規定と矛盾する場合には，個別規定において特段の定めなき限り，個別規定の規定が優先されるものとします。
              </li>
            </ol>
          </Box>
          <Box mb={3}>
            <HelpContentItemTitle itemTitle="第2条（利用登録）" />
            <ol className={classes.ol}>
              <li className={classes.li}>
                登録希望者が当サービス提供者の定める方法によって利用登録を申請し，当サービス提供者がこれを承認することによって，利用登録が完了するものとします。
              </li>
              <li className={classes.li}>
                当サービス提供者は，利用登録の申請者に以下の事由があると判断した場合，利用登録の申請を承認しないことがあり，その理由については一切の開示義務を負わないものとします。
              </li>
              <ol className={classes.ol}>
                <li className={classes.li}>本規約に違反したことがある者からの申請である場合</li>
                <li className={classes.li}>
                  反社会的勢力等（暴力団，暴力団員，右翼団体，反社会的勢力，その他これに準ずる者を意味します。）である，または資金提供その他を通じて反社会的勢力等の維持，運営もしくは経営に協力もしくは関与する等反社会的勢力との何らかの交流もしくは関与を行っていると当サービス提供者が判断した場合
                </li>
                <li className={classes.li}>その他，当サービス提供者が利用登録を相当でないと判断した場合</li>
              </ol>
            </ol>
          </Box>
          <Box mb={3}>
            <HelpContentItemTitle itemTitle="第3条（ユーザーIDおよびパスワードの管理）" />
            <ol className={classes.ol}>
              <li className={classes.li}>
                ユーザーは，自己の責任において，本サービスのユーザーIDおよびパスワードを管理するものとします。
              </li>
              <li className={classes.li}>
                ユーザーは，いかなる場合にも，ユーザーIDおよびパスワードを第三者に譲渡または貸与することはできません。当サービス提供者は，ユーザーIDとパスワードの組み合わせが登録情報と一致してログインされた場合には，そのユーザーIDを登録しているユーザー自身による利用とみなします。
              </li>
            </ol>
          </Box>
          <Box mb={3}>
            <HelpContentItemTitle itemTitle="第4条（利用料金および支払方法）" />
            <p className={classes.p}>
              ユーザーは，本サービスの有料部分の対価として，当サービス提供者が別途定め，本ウェブサイトに表示する利用料金を，当サービス提供者が指定する方法により支払うものとします。
            </p>
          </Box>
          <Box mb={3}>
            <HelpContentItemTitle itemTitle="第5条（禁止事項）" />
            <p className={classes.p}>ユーザーは，本サービスの利用にあたり，以下の行為をしてはなりません。</p>
            <ol className={classes.ol}>
              <li className={classes.li}>法令または公序良俗に違反する行為</li>
              <li className={classes.li}>犯罪行為に関連する行為</li>
              <li className={classes.li}>
                当サービス提供者のサーバーまたはネットワークの機能を破壊したり，妨害したりする行為
              </li>
              <li className={classes.li}>当サービス提供者のサービスの運営を妨害するおそれのある行為</li>
              <li className={classes.li}>他のユーザーに関する個人情報等を収集または蓄積する行為</li>
              <li className={classes.li}>他のユーザーに成りすます行為</li>
              <li className={classes.li}>不正アクセスをし，またはこれを試みる行為</li>
              <li className={classes.li}>
                当サービス提供者のサービスに関連して，反社会的勢力に対して直接または間接に利益を供与する行為
              </li>
              <li className={classes.li}>
                当サービス提供者，本サービスの他の利用者または第三者の知的財産権，肖像権，プライバシー，名誉その他の権利または利益を侵害する行為
              </li>
              <li className={classes.li}>
                以下の表現を含み，または含むと当サービス提供者が判断する内容を本サービス上に投稿し，または送信する行為
              </li>
              <ol className={classes.ol}>
                <li className={classes.li}>過度に暴力的な表現</li>
                <li className={classes.li}>露骨な性的表現</li>
                <li className={classes.li}>人種，国籍，信条，性別，社会的身分，門地等による差別につながる表現</li>
                <li className={classes.li}>自殺，自傷行為，薬物乱用を誘引または助長する表現</li>
                <li className={classes.li}>その他反社会的な内容を含み他人に不快感を与える表現</li>
              </ol>
              <li className={classes.li}>以下を目的とし，または目的とすると当サービス提供者が判断する行為</li>
              <ol className={classes.ol}>
                <li className={classes.li}>
                  営業，宣伝，広告，勧誘，その他営利を目的とする行為（当サービス提供者の認めたものを除きます。）
                </li>
                <li className={classes.li}>性行為やわいせつな行為を目的とする行為</li>
                <li className={classes.li}>面識のない異性との出会いや交際を目的とする行為</li>
                <li className={classes.li}>他のユーザーに対する嫌がらせや誹謗中傷を目的とする行為</li>
                <li className={classes.li}>
                  当サービス提供者，本サービスの他のユーザー，または第三者に不利益，損害または不快感を与えることを目的とする行為
                </li>
                <li className={classes.li}>
                  その他本サービスが予定している利用目的と異なる目的で本サービスを利用する行為
                </li>
              </ol>
              <li className={classes.li}>宗教活動または宗教団体への勧誘行為</li>
              <li className={classes.li}>その他，当サービス提供者が不適切と判断する行為</li>
            </ol>
          </Box>
          <Box mb={3}>
            <HelpContentItemTitle itemTitle="第6条（本サービスの提供の停止等）" />
            <ol className={classes.ol}>
              <li className={classes.li}>
                当サービス提供者は，以下のいずれかの事由があると判断した場合，ユーザーに事前に通知することなく本サービスの全部または一部の提供を停止または中断することができるものとします。
                <ol className={classes.ol}>
                  <li className={classes.li}>本サービスにかかるコンピュータシステムの保守点検または更新を行う場合</li>
                  <li className={classes.li}>
                    地震，落雷，火災，停電または天災などの不可抗力により，本サービスの提供が困難となった場合
                  </li>
                  <li className={classes.li}>コンピュータまたは通信回線等が事故により停止した場合</li>
                  <li className={classes.li}>その他，当サービス提供者が本サービスの提供が困難と判断した場合</li>
                </ol>
              </li>
              <li className={classes.li}>
                当サービス提供者は，本サービスの提供の停止または中断により，ユーザーまたは第三者が被ったいかなる不利益または損害についても，一切の責任を負わないものとします。
              </li>
            </ol>
          </Box>
          <Box mb={3}>
            <HelpContentItemTitle itemTitle="第7条（著作権）" />
            <ol className={classes.ol}>
              <li className={classes.li}>
                ユーザーは，自ら著作権等の必要な知的財産権を有するか，または必要な権利者の許諾を得た文章，画像や映像等の情報に関してのみ，本サービスを利用し，投稿ないしアップロードすることができるものとします。
              </li>
              <li className={classes.li}>
                ユーザーが本サービスを利用して投稿ないしアップロードした文章，画像，映像等の著作権については，当該ユーザーその他既存の権利者に留保されるものとします。ただし，当サービス提供者は，本サービスを利用して投稿ないしアップロードされた文章，画像，映像等について，本サービスの改良，品質の向上，または不備の是正等ならびに本サービスの周知宣伝等に必要な範囲で利用できるものとし，ユーザーは，この利用に関して，著作者人格権を行使しないものとします。
              </li>
              <li className={classes.li}>
                前項本文の定めるものを除き，本サービスおよび本サービスに関連する一切の情報についての著作権およびその他の知的財産権はすべて当サービス提供者または当サービス提供者にその利用を許諾した権利者に帰属し，ユーザーは無断で複製，譲渡，貸与，翻訳，改変，転載，公衆送信（送信可能化を含みます。），伝送，配布，出版，営業使用等をしてはならないものとします。
              </li>
            </ol>
          </Box>
          <Box mb={3}>
            <HelpContentItemTitle itemTitle="第8条（利用制限および登録抹消）" />
            <ol className={classes.ol}>
              <li className={classes.li}>
                当サービス提供者は，ユーザーが以下のいずれかに該当する場合には，事前の通知なく，投稿データを削除し，ユーザーに対して本サービスの全部もしくは一部の利用を制限しまたはユーザーとしての登録を抹消することができるものとします。
                <ol className={classes.ol}>
                  <li className={classes.li}>本規約のいずれかの条項に違反した場合</li>
                  <li className={classes.li}>登録事項に虚偽の事実があることが判明した場合</li>
                  <li className={classes.li}>
                    決済手段として当該ユーザーが届け出たクレジットカードが利用停止となった場合
                  </li>
                  <li className={classes.li}>料金等の支払債務の不履行があった場合</li>
                  <li className={classes.li}>当サービス提供者からの連絡に対し，一定期間返答がない場合</li>
                  <li className={classes.li}>本サービスについて，最終の利用から一定期間利用がない場合</li>
                  <li className={classes.li}>その他，当サービス提供者が本サービスの利用を適当でないと判断した場合</li>
                </ol>
              </li>
              <li className={classes.li}>
                前項各号のいずれかに該当した場合，ユーザーは，当然に当サービス提供者に対する一切の債務について期限の利益を失い，その時点において負担する一切の債務を直ちに一括して弁済しなければなりません。
              </li>
              <li className={classes.li}>
                当サービス提供者は，本条に基づき当サービス提供者が行った行為によりユーザーに生じた損害について，一切の責任を負いません。
              </li>
            </ol>
          </Box>
          <Box mb={3}>
            <HelpContentItemTitle itemTitle="第9条（退会）" />
            <p className={classes.p}>
              ユーザーは，当サービス提供者の定める退会手続により，本サービスから退会できるものとします。
            </p>
          </Box>
          <Box mb={3}>
            <HelpContentItemTitle itemTitle="第10条（保証の否認および免責事項）" />
            <ol className={classes.ol}>
              <li className={classes.li}>
                当サービス提供者は，本サービスに事実上または法律上の瑕疵（安全性，信頼性，正確性，完全性，有効性，特定の目的への適合性，セキュリティなどに関する欠陥，エラーやバグ，権利侵害などを含みます。）がないことを明示的にも黙示的にも保証しておりません。
              </li>
              <li className={classes.li}>
                当サービス提供者は，本サービスに起因してユーザーに生じたあらゆる損害について一切の責任を負いません。
              </li>
              <li className={classes.li}>
                当サービス提供者は，当サービス提供者の過失（重過失を除きます。）による債務不履行または不法行為によりユーザーに生じた損害のうち特別な事情から生じた損害（当サービス提供者またはユーザーが損害発生につき予見し，または予見し得た場合を含みます。）について一切の責任を負いません。
              </li>
              <li className={classes.li}>
                当サービス提供者は，本サービスに関して，ユーザーと他のユーザーまたは第三者との間において生じた取引，連絡または紛争等について一切責任を負いません。
              </li>
            </ol>
          </Box>
          <Box mb={3}>
            <HelpContentItemTitle itemTitle="第11条（サービス内容の変更等）" />
            <p className={classes.p}>
              当サービス提供者は，ユーザーに通知することなく，本サービスの内容を変更しまたは本サービスの提供を中止することができるものとし，これによってユーザーに生じた損害について一切の責任を負いません。
            </p>
          </Box>
          <Box mb={3}>
            <HelpContentItemTitle itemTitle="第12条（利用規約の変更）" />
            <p className={classes.p}>
              当サービス提供者は，必要と判断した場合には，ユーザーに通知することなくいつでも本規約を変更することができるものとします。なお，本規約の変更後，本サービスの利用を開始した場合には，当該ユーザーは変更後の規約に同意したものとみなします。
            </p>
          </Box>
          <Box mb={3}>
            <HelpContentItemTitle itemTitle="第13条（個人情報の取扱い）" />
            <p className={classes.p}>
              当サービス提供者は，本サービスの利用によって取得する個人情報については，当サービス提供者「プライバシーポリシー」に従い適切に取り扱うものとします。
            </p>
          </Box>
          <Box mb={3}>
            <HelpContentItemTitle itemTitle="第14条（通知または連絡）" />
            <p className={classes.p}>
              ユーザーと当サービス提供者との間の通知または連絡は，当サービス提供者の定める方法によって行うものとします。当サービス提供者は,ユーザーから,当サービス提供者が別途定める方式に従った変更届け出がない限り,現在登録されている連絡先が有効なものとみなして当該連絡先へ通知または連絡を行い,これらは,発信時にユーザーへ到達したものとみなします。
            </p>
          </Box>
          <Box mb={3}>
            <HelpContentItemTitle itemTitle="第15条（権利義務の譲渡の禁止）" />
            <p className={classes.p}>
              ユーザーは，当サービス提供者の書面による事前の承諾なく，利用契約上の地位または本規約に基づく権利もしくは義務を第三者に譲渡し，または担保に供することはできません。
            </p>
          </Box>
          <Box mb={3} textAlign="right">
            <p className={classes.p}>以上</p>
          </Box>
        </Container>
      </main>
      <Footer />
    </>
  )
}

export default TermsOfUse
