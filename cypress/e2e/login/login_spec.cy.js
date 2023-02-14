describe('Login', function() {
  var url = "/login"
  var email = "admin@domain.com"
  var password = "domainpw"

  beforeEach(() => {
    cy.visit(url);
  })
  
  it('Login with valid credentials', function() {
    cy.get("#email").type(email).should("have.value", email);
    cy.get("#password").type(password).should("have.value", password);
    cy.contains("Log in").click();
    cy.get('[data-cy="header-edit-profile-button"]').should("have.value", "admin");
    cy.get('[data-cy="header-logout-button"]');
    cy.log('Login successful')
    cy.get('[data-cy="header-logout-button"]').click();
    cy.url().should('include', '/login')
  })
 
  it('Login with invalid credentials - invalid email', function() {
    const invalidemail = "admin@admin.com";
    cy.get("#email").type(invalidemail).should("have.value", invalidemail);
    cy.get("#password").type(password).should("have.value", password);
    cy.contains("Log in").click();
    cy.on('window:alert',(t)=>{ expect(t).to.contains('Invalid Email or password'); });
  })

  it("Login with invalid credentials - invalid password", function () {
    const invalidpassword = "admin@.com";
    cy.get("#email").type(email).should("have.value", email);
    cy.get("#password").type(invalidpassword).should("have.value", invalidpassword);
    cy.contains("Log in").click();
    cy.on('window:alert',(t)=>{ expect(t).to.contains('Invalid Email or password'); });
  });
  
})