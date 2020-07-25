// Functions without cypress commands

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

// recursiveAssign is nested Object.assign
function recursiveAssign(a, b) {
	const bIsObject = (Object(b) === b);
	if (!bIsObject) {
		return b;
	}

	const aIsObject = (Object(a) === a);
	if (!aIsObject) {
		if (b instanceof Array) {
			a = [];
		} else {
			a = {};
		}
	}
	for (const key of Object.keys(b)) {
		a[key] = recursiveAssign(a[key], b[key]);
	}
	return a;
}

