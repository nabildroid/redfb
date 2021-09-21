import axios, { AxiosInstance } from "axios";

export interface ITranslate {
	convert(origin: string): Promise<string>;
}

export default class Translate implements ITranslate {
	private readonly client: AxiosInstance;

	constructor(auth: string) {
		this.client = axios.create({
			baseURL: "dsddsd",
			method: "POST",
			headers: {
				auth: `brear ${auth}`,
			},
		});
	}

	async convert(origin: string): Promise<string> {
        return "Translated";
		// const response = await this.client.request({
		// 	data: origin,
		// });

		// return response.data as string;
	}
}
