describe('利用規約ページ', () => {
  const baseUrl = Cypress.env('baseUrl')
  const terms_of_use_url = `${baseUrl}/help/terms_of_use`
  it('遷移できること', () => {
    cy.visit(terms_of_use_url)
    cy.get('[data-testid=header-title]').contains('利用規約').should('exist')

    // スナップショットテスト
    cy.matchImageSnapshot('termsOfUse')
  })
})
