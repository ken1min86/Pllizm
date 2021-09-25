describe('プライバシーポリシーページ', () => {
  const baseUrl = Cypress.env('baseUrl')
  const privacy_policy_url = `${baseUrl}/help/privacy_policy`
  it('遷移できること', () => {
    cy.visit(privacy_policy_url)
    cy.get('[data-testid=header-title]').contains('プライバシーポリシー').should('exist')

    // スナップショットテスト
    cy.matchImageSnapshot('privacyPolicy')
  })
})
