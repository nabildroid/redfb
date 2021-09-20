import RedditPost from "../entities/redditPost";

export interface IRedit {
	getPosts(): Promise<RedditPost[]>;
}

export class Reddit implements IRedit {
	readonly id: string;

	constructor(id: string) {
		this.id = id;
	}

	async getPosts(): Promise<RedditPost[]> {
		return [];
	}
}
