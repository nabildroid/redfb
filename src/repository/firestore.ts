import Config from "../entities/config";
import Post, { Content, PostState } from "../entities/post";
import admin from "firebase-admin";
import { objectify } from "../utils";

export interface IStore {
	getConfig(): Promise<Config>;

	getPublishQueue(): Promise<Post[]>;
	getTranslationQueue(): Promise<Post[]>;

	push(content: Content, id: string, source: string): Promise<void>;

	move(id: string, translation: string): Promise<void>;
	done(id: string): Promise<void>;
}
const CONFIG = "/config/config";
const POSTS = "/posts";

export default class Store implements IStore {
	private readonly db: FirebaseFirestore.Firestore;
	constructor(auth: any) {
		admin.initializeApp({
			credential: admin.credential.cert(auth),
		});

		this.db = admin.firestore();
	}

	async getConfig(): Promise<Config> {
		const doc = await this.db.doc(CONFIG).get();
		const data = (doc.data() as Config) || {};

		const config: Config = {
			ins_outs: data.ins_outs || {},
			scheduler: {
				minUpVotes: data.scheduler?.minUpVotes || 0,
				maxExtractions: data.scheduler?.maxExtractions || 4,
				publishHours: data.scheduler?.publishHours || [788, 7],
			},
			facebook_auth:
				data.facebook_auth ||
				process.env.FACEBOOK_AUTH ||
				(() => {
					throw Error("facebook auth token doesn't exists");
				})(),
			translation_auth:
				data.translation_auth ||
				process.env.TRANSLATION_AUTH ||
				(() => {
					throw Error("translation_auth token doesn't exists");
				})(),
		};

		if (!doc.exists) {
			await this.setConfig(config);
		}
		return config;
	}

	private async setConfig(config: Config) {
		await this.db.doc(CONFIG).set(config);
	}

	async getPublishQueue(): Promise<Post[]> {
		const docs = await this.filterPostByState(PostState.translated);
		if (docs.size) {
			return docs.docs.map(this.converPostDocToPost);
		} else return [];
	}
	async getTranslationQueue(): Promise<Post[]> {
		const docs = await this.filterPostByState(PostState.pure);
		if (docs.size) {
			return docs.docs.map(this.converPostDocToPost);
		} else return [];
	}

	async push(content: Content, id: string, source: string): Promise<void> {
		const post: Post = {
			id,
			state: PostState.pure,
			content: objectify(content),
			source,
			date: new Date(),
		};

		console.log({
			...post,
			date: admin.firestore.Timestamp.fromDate(post.date),
		});
		await this.db
			.collection(POSTS)
			.doc(id)
			.set({
				...post,
				date: admin.firestore.Timestamp.fromDate(post.date),
			});
	}

	async move(id: string, translation: string): Promise<void> {
		await this.db.collection(POSTS).doc(id).update({
			"content.translation": translation,
			state: PostState.translated,
		});
	}
	async done(id: string) {
		this.db.collection(POSTS).doc(id).update({
			state: PostState.published,
		});
	}

	private filterPostByState(state: PostState) {
		return this.db.collection(POSTS).where("state", "==", state).get();
	}

	private converPostDocToPost(doc: FirebaseFirestore.DocumentSnapshot): Post {
		const data = doc.data();
		return {
			...data,
			date: (data?.date as FirebaseFirestore.Timestamp).toDate(),
		} as Post;
	}
}
