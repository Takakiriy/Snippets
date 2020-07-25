// Functions having cypress commands
import * as lib from "./my-lib.js"

export function  visitSync( targetURL, watiForURL, option ) {
	if ( ! watiForURL ) {
		watiForURL = targetURL
	}

	cy.visit( targetURL )
	cy.location('href', option).should('eq', watiForURL)
}

// log
export function  log( label,  value ) {
	if (typeof value === 'object') {
		expect( label ).to.not.eq( lib.recursiveAssign( {}, value ) )
	} else if ( label === value ) {
		expect( label ).to.eq( value )
	} else {
		expect( label ).to.not.eq( value )
	}
}

// saveCookies
Cypress.Commands.add("saveCookies", ( path: string ) => {
	cy.getCookies().then((cookies) => {

		cy.writeFile("_cookie.json", cookies)
			// cypress を起動したときのカレント フォルダーからの相対パス
	})
})

// saveLogInLocalStorage
// Example: cmd.saveLogInLocalStorage()
export function  saveLogInLocalStorage() {
	cy.writeFile("_logInLocalStorage.json",  getLocalStorage() )
}

// restoreLogInLocalStorage
// Example: cmd.restoreLogInLocalStorage()
export function  restoreLogInLocalStorage() {
	cy.clearLocalStorage()
	cy.readFile("_logInLocalStorage.json").then( (storage) => {  // cypress を起動したときのカレント フォルダーからの相対パス
		setLocalStorage( storage )
	})
})

// setLocalStorage
export function  setLocalStorage(keyValue) {
	for (const key of Object.keys(keyValue)) {
		localStorage.setItem( key, keyValue[key] )
	}
}

// getLocalStorage
export function  getLocalStorage() {
	const  storage = {}
	for (var i = 0; i < localStorage.length; i++) {
		const  key = localStorage.key(i)
		const  item = localStorage.getItem( key )
		storage[ key ] = item
	}
	return  storage
}

