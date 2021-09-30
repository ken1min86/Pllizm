describe('サインインモーダル', () => {
  const baseUrl = Cypress.env('baseUrl')
  const topUrl = baseUrl
  const email = 'test@test.com'
  const password = 'password'
  it('表示できること', () => {
    cy.visit(topUrl)
    cy.get('button').contains('ログイン').click()
    cy.get('[data-testid=title]').contains('ログイン').should('exist')

    // スナップショットテスト
    cy.matchImageSnapshot('termsOfUse')
  })

  it('閉じられること', () => {
    cy.visit(topUrl)
    cy.get('button').contains('ログイン').click()
    cy.get('[data-testid=close-button]').click()
    cy.get('[data-testid=header-title]').contains('こっちも現実').should('exist')
  })

  // it('サインインできること', () => {
  //   cy.visit(topUrl)
  //   cy.get('a').contains('ログイン').click()
  //   cy.get('#outlined-helperText').type(email)
  //   cy.get('#outlined-password-input').type(password)
  //   cy.get('button').contains('ログイン').click()
  // })

  it('パスワード再設定ページに遷移できること', () => {
    cy.visit(topUrl)
    cy.get('button').contains('ログイン').click()
    cy.get('a').contains('パスワードをお忘れの方はこちら').click()
    cy.get('[data-testid=title]').contains('パスワードをリセットする').should('exist')
  })

  it('アカウント作成ページに遷移できる', () => {
    cy.visit(topUrl)
    cy.get('button').contains('ログイン').click()
    cy.get('[data-testid=signup-link-in-text]').contains('アカウント作成').click()
    cy.get('[data-testid=title]').contains('アカウント作成').should('exist')
  })

  it('利用規約ページに遷移できる', () => {
    cy.visit(topUrl)
    cy.get('button').contains('ログイン').click()
    cy.get('[data-testid=terms-of-use-link-in-modal]').click()
    cy.get('[data-testid=header-title]').contains('利用規約').should('exist')
  })

  it('プライバシーポリシーページに遷移できる', () => {
    cy.visit(topUrl)
    cy.get('button').contains('ログイン').click()
    cy.get('[data-testid=privacy-policy-link-in-modal]').click()
    cy.get('[data-testid=header-title]').contains('プライバシーポリシー').should('exist')
  })
})
