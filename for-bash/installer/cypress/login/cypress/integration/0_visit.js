context('Location', () => {
	before('cy.location()', () => {

		cy.visit('https://example.cypress.io/commands/location')
	})

	it( 'visited', () => {
		cy.location().should((location) => {
			expect(location.href).to.eq('https://example.cypress.io/commands/location')

			const  object = { "a": 1, "b": { "c": 2 } }
			expect("debug-111").to.not.eq( object )
			object.a = 2
		})
	})
})
