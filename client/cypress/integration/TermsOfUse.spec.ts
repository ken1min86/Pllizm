describe('利用規約ページ', () => {
  const baseUrl = Cypress.env('baseUrl');
  const terms_of_use_url = `${baseUrl}/help/terms_of_use`;
  it('遷移できること', () => {
    cy.visit(terms_of_use_url);
    cy.get('[data-testid=terms-of-use-header]');

    // スナップショットテスト
    cy.matchImageSnapshot('termsOfUse');
  });
});
