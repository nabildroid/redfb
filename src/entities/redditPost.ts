export default interface RedditPost {
	id: string;
	upvotes: number;
	image?: string;
	date: Date;
	title: string;
}
