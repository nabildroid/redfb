import Post from "../entities/post";
import { IFacebookClient } from "./facebookClient";

export interface IFacebook {
	post(post: Post): Promise<void>;
}

export default class Facebook implements IFacebook {
	readonly id: string;
	readonly client: IFacebookClient;

	constructor(id: string, client: IFacebookClient) {
		this.id = id;
		this.client = client;
	}

	post(post: Post): Promise<void> {
		throw new Error("Method not implemented.");
	}
}
