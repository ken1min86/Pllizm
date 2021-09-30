describe('プライバシーポリシーページ', () => {
  const baseUrl = Cypress.env('baseUrl')
  const privacyPolicyUrl = `${baseUrl}/help/privacy_policy`
  it('遷移できること', () => {
    cy.visit(privacyPolicyUrl)
    cy.get('[data-testid=header-title]').contains('プライバシーポリシー').should('exist')

    // スナップショットテスト
    cy.matchImageSnapshot('privacyPolicy')
  })
})
