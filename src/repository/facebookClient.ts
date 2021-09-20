export interface IFacebookClient {}

export default class FacebookClient implements IFacebookClient {
	private readonly auth: string;

	constructor(auth: string) {
		this.auth = auth;
	}
}
