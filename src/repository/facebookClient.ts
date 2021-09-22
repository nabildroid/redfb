import axios, { AxiosInstance } from "axios";

export interface IFacebookClient {
	post(pageId: string, message: string): Promise<void>;
	postImage(
		pageId: string,
		image_url: string,
		message?: string
	): Promise<void>;
}

export default class FacebookClient implements IFacebookClient {
	private readonly client: AxiosInstance;

	constructor(auth: string) {
		this.client = axios.create({
			baseURL: "https://graph.facebook.com",
			params: {
				access_token: auth,
			},
		});
	}

	async post(pageId: string, message: string): Promise<void> {
		try {
			const response = await this.client.post(
				`${pageId}/feed`,
				{},
				{
					params: { message },
				}
			);
		} catch (error) {
			console.error(error);
		}
	}
	async postImage(
		pageId: string,
		image_url: string,
		message?: string
	): Promise<void> {
		await this.client.post(
			`${pageId}/photos`,
			{},
			{
				params: { message, url: image_url },
			}
		);
	}
}
