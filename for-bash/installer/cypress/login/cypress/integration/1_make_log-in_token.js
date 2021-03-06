import * as cmd from "../my-cmd.js"
import * as lib from "../my-lib.js"
const httpOrigin = lib.env('HttpOrigin')

describe('Location', () => {
	before(() => {

		// It is necessary to restart cypress main window after edit ../../cypress.env.json file.
		// Example:
		//    {
		//        "HttpOrigin": "http://localhost:8080/",
		//        "LogInToken": "InCookie",  // "InCookie" or "InLocalStorage"
		//        "LogInAccount": "tester",
		//        "LogInPassword": "123456"
		//    }
		expect(lib.env( 'HttpOrigin' )).be.not.eq("")
		expect(lib.env( 'LogInAccount' )).be.not.eq("")
		expect(lib.env( 'LogInPassword' )).be.not.eq("")

		// visit httpOrigin
		cy.clearCookies()
		cy.clearLocalStorage()

		cmd.visitSync( httpOrigin,  httpOrigin + 'signin', {timeout: 5000} )
	})

	it( 'visited', () => {

		cy.get('[data-test="username-input"]').type(lib.env( 'LogInAccount' ))
		cy.get('[data-test="sign-in-password-input"]').type(lib.env( 'LogInPassword' )+`{enter}`)

		cy.location('href').should('eq', httpOrigin).then( (href)=>{
			cmd.saveLogInToken()
		})
	})
})

