import RedditPost from "../entities/redditPost";
import axios, { AxiosInstance, AxiosResponse } from "axios";

export interface IRedit {
	getPosts(): Promise<RedditPost[]>;
}

export class Reddit implements IRedit {
	readonly id: string;
	readonly client: AxiosInstance;
	constructor(id: string) {
		this.id = id;
		this.client = axios.create({
			baseURL: `https://www.reddit.com/r/${id}/top.json`,
			method: "GET",
			responseType: "json",
		});
	}

	async getPosts(): Promise<RedditPost[]> {
		const response = await this.client.request({});
		
		return this.parseRedditResponse(response);

		// return [
		// 	{
		// 		date: new Date(),
		// 		id: "ded87987998",
		// 		title: "Hello World",
		// 		upvotes: 450,
		// 	},
		// ];
	}

	private parseRedditResponse(response:AxiosResponse<any>):RedditPost[]{
		try {
			const  children= response.data.data.children as any[];
			const items = children.map(({data})=>data);
			return items.map(item=>({
				id:item.id,
				upvotes:item.ups,
				title:item.title,
				date:new Date(item.created * 1000)
			}));

		} catch (error) {
			throw Error(`unable to parse Reddit ${this.id} response`);
		}
	}

	
}
