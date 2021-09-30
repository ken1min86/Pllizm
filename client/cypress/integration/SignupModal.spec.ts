describe('サインアップモーダル', () => {
  const baseUrl = Cypress.env('baseUrl')
  const topUrl = baseUrl
  const email = 'test@test.com'
  const password = 'password'
  it('表示できること', () => {
    cy.visit(topUrl)
    cy.get('button').contains('アカウント作成').click()
    cy.get('[data-testid=title]').contains('アカウント作成').should('exist')

    // スナップショットテスト
    cy.matchImageSnapshot('termsOfUse')
  })

  it('閉じられること', () => {
    cy.visit(topUrl)
    cy.get('button').contains('アカウント作成').click()
    cy.get('[data-testid=close-button]').click()
    cy.get('[data-testid=header-title]').contains('こっちも現実').should('exist')
  })

  it('ログインページに遷移できる', () => {
    cy.visit(topUrl)
    cy.get('button').contains('アカウント作成').click()
    cy.get('[data-testid=signin-link-in-text]').click()
    cy.get('[data-testid=title]').contains('アカウント作成').should('exist')
  })

  it('利用規約ページに遷移できる', () => {
    cy.visit(topUrl)
    cy.get('button').contains('アカウント作成').click()
    cy.get('[data-testid=terms-of-use-link-in-modal]').click()
    cy.get('[data-testid=header-title]').contains('利用規約').should('exist')
  })

  it('プライバシーポリシーページに遷移できる', () => {
    cy.visit(topUrl)
    cy.get('button').contains('アカウント作成').click()
    cy.get('[data-testid=privacy-policy-link-in-modal]').click()
    cy.get('[data-testid=header-title]').contains('プライバシーポリシー').should('exist')
  })
})
