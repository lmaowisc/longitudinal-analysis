CREATE TABLE `comments` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`body` text NOT NULL,
	`lecture` integer,
	`created_at` integer NOT NULL,
	`delete_hash` text NOT NULL,
	`visitor_hash` text NOT NULL
);
--> statement-breakpoint
CREATE INDEX `comments_created_idx` ON `comments` (`created_at`);--> statement-breakpoint
CREATE INDEX `comments_visitor_idx` ON `comments` (`visitor_hash`,`created_at`);