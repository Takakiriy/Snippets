import * as cmd from "../my-cmd.js"
import * as lib from "../my-lib.js"
const httpOrigin = lib.env('HttpOrigin')

describe('Automatic log in and click hyper link', () => {
	beforeEach(() => {
		cmd.restoreLogInToken()
		cmd.visitSync( httpOrigin )
	})

	it( 'a', () => {
		cy.get('[id="webAPIURL"]').click()
		cy.go('back')
	})

	it( 'b', () => {
		cy.get('[id="webAPIURLMy"]').click()
		cy.go('back')
	})
})
