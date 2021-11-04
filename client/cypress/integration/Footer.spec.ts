describe('フッター', () => {
  const baseUrl = Cypress.env('baseUrl')
  const topUrl = baseUrl
  it('利用規約ページに遷移できること', () => {
    cy.visit(topUrl)
    cy.get('[data-testid=terms-of-use-link]').click()
    cy.get('[data-testid=header-title]').contains('利用規約').should('exist')
  })

  it('プライバシーポリシーページに遷移できること', () => {
    cy.visit(topUrl)
    cy.get('[data-testid=privacy-policy-link]').click()
    cy.get('[data-testid=header-title]').contains('プライバシーポリシー').should('exist')
  })
})
