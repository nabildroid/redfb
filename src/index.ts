import Express from "express";
const app = Express();

app.use(Express.json());

import Config from "./entities/config";
import Facebook from "./repository/facebook";
import FacebookClient from "./repository/facebookClient";
import Store from "./repository/firestore";
import { Reddit } from "./repository/reddit";
import Translate, { ITranslate } from "./repository/translate";
import serviceAccount from "../service-account.json";

const isProd = process.env.NODE_ENV == "production";
const store = new Store(isProd ? process.env.SERVICE_ACCOUNT : serviceAccount);

let translation: ITranslate;
let config: Config;

app.get("/extract", async (req, res) => {
	const ids = Object.keys(config.ins_outs);
	const subreddits = ids.map((key) => new Reddit(key));
	for (const sub of subreddits) {
		const redditPosts = await sub.getPosts();

		const publishing = redditPosts.map(async (rpost) => {
			console.log(rpost);
			const generatedTranslation = await translation.convert(rpost.title);
			await store.push(
				{
					origin: rpost.title,
					generatedTranslation,
					image: rpost.image,
				},
				rpost.id,
				sub.id
			);
		});
		await Promise.all(publishing);
	}
	res.send("done");
});

app.post("/move", async (req, res) => {
	const body = req.body;
	console.log(body);
	if (!body.id || !body.translation) {
		return res.status(301).send("error");
	} else {
		await store.move(body.id, body.translation);
		return res.send("done");
	}
});

app.get("/queue", async (req, res) => {
	const posts = await store.getTranslationQueue();
	return res.json(posts);
});

app.post("/publish", async (req, res) => {
	const times = config.scheduler.publishHours;
	const now = [new Date().getHours(), new Date().getMinutes()];

	const allowed =
		times.some((timeNum) => {
			const time = [timeNum / 60, timeNum % 60];
			return time[0] == now[0] && time[1] == now[0];
		}) || true;

	if (allowed) {
		const FBClient = new FacebookClient(config.facebook_auth);
		const subreddits_ids = new Set();

		const posts = await store.getPublishQueue();
		for (const post of posts) {
			if (subreddits_ids.has(post.source)) continue;
			subreddits_ids.add(post.source);

			const pageId = config.ins_outs[post.source];
			const page = new Facebook(pageId, FBClient);

			await page.post(post.content);
			await store.done(post.id);
		}

		res.send("done");
	} else {
		return res.sendStatus(301).send("waiting...");
	}
});

const PORT = process.env.PORT ?? 8080;

app.listen(PORT, async () => {
	config = await store.getConfig();
	translation = new Translate(config.translation_auth);

	console.log("listening111");
});
