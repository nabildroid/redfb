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

	async post(post: Post): Promise<void> {
		console.log("posing " + post.id + " in facebook page @" + this.id);
	}
}
