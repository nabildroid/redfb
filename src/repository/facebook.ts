import Post, { Content } from "../entities/post";
import { IFacebookClient } from "./facebookClient";

export interface IFacebook {
	post(post: Content): Promise<void>;
}

export default class Facebook implements IFacebook {
	readonly id: string;
	readonly client: IFacebookClient;

	constructor(id: string, client: IFacebookClient) {
		this.id = id;
		this.client = client;
	}

	async post(post: Content): Promise<void> {
		if (post.image) {
			await this.client.postImage(this.id, post.image, post.translation!);
		} else {
			await this.client.post(this.id, post.translation!);
		}
	}
}
