export function objectify<T extends { [key: string]: any } >(obj:T ) {
	Object.keys(obj).forEach((key) =>
		obj[key] === undefined ? delete obj[key] : {}
	);

	return obj;
}
