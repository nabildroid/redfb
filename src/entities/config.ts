export interface Scheduler {
	publishHours: number[];
	maxExtractions: number;
	minUpVotes: number;
}

export default interface Config {
	ins_outs: { [key: string]: string };
	scheduler: Scheduler;
	facebook_auth: string;
}
