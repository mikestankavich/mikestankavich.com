export type SiteConfig = {
	author: string;
	title: string;
	description: string;
	lang: string;
	ogLocale: string;
	date: {
		locale: string | string[] | undefined;
		options: Intl.DateTimeFormatOptions;
	};
};

export type PaginationLink = {
	url: string;
	text?: string;
	srLabel?: string;
};

export type SiteMeta = {
	title: string;
	description?: string;
	ogImage?: string | undefined;
	articleDate?: string | undefined;
};

export type CvData = {
	name: string;
	title: string;
	email: string;
	phone: string;
	website: string;
	linkedin: string;
	github: string;
	twitter: string;
	location: string;
	summary: string;
	experience: Content[];
	education: Content[];
	projects: Proj[];
	skills: Record<string, string[]>[];
	certifications: Cert[];
};

export type Content = {
	title: string;
	company: string;
	location: string;
	dateRange: string;
	description: string[];
};

export type Proj = {
	title: string;
	description: string;
	href: string;
	imagePath: string;
};

export type Cert = {
	issuer: string;
	name: string;
	issued: string;
	href: string;
};
