describe('トップページ', () => {
  const baseUrl = Cypress.env('baseUrl')
  const topUrl = baseUrl
  it('遷移できること', () => {
    cy.visit(topUrl)
    cy.get('[data-testid=header-title]').contains('こっちも現実').should('exist')

    // スナップショットテスト
    cy.matchImageSnapshot('top')
  })
})
