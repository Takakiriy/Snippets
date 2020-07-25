import * as cmd from "../my-cmd.js"
import * as lib from "../my-lib.js"
const httpOrigin = Cypress.env('HttpOrigin')

describe('None', () => {
	before(() => {
		cmd.restoreLogInLocalStorage()
		cmd.visitSync( httpOrigin )
	})

	it( 'a', () => {
		cy.log("1",1)
	})

	it( 'b', () => {
		cy.log("2",1)
	})
})
