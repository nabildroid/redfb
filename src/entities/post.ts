export enum PostState {
	pure,
	translated,
	published,
}

export interface Content {
	origin: string;
	generatedTranslation?: string;
	translation?: string;
	image?: string;
}

export default interface Post {
	state: PostState;
	content: Content;
	source: string;
	date: Date;
	id: string;
}
