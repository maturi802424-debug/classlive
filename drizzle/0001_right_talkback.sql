CREATE TABLE `likes` (
	`post_id` text NOT NULL,
	`participant_id` text NOT NULL,
	FOREIGN KEY (`post_id`) REFERENCES `posts`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`participant_id`) REFERENCES `participants`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `idx_likes_post` ON `likes` (`post_id`);--> statement-breakpoint
CREATE TABLE `reactions` (
	`id` text PRIMARY KEY NOT NULL,
	`session_id` text NOT NULL,
	`participant_id` text NOT NULL,
	`emoji` text NOT NULL,
	`created_at` integer NOT NULL,
	FOREIGN KEY (`session_id`) REFERENCES `sessions`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`participant_id`) REFERENCES `participants`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `idx_reactions_session_created` ON `reactions` (`session_id`,`created_at`);--> statement-breakpoint
CREATE TABLE `reflections` (
	`id` text PRIMARY KEY NOT NULL,
	`session_id` text NOT NULL,
	`participant_id` text NOT NULL,
	`takeaway` text NOT NULL,
	`changed` text DEFAULT '' NOT NULL,
	`created_at` integer NOT NULL,
	FOREIGN KEY (`session_id`) REFERENCES `sessions`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`participant_id`) REFERENCES `participants`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `idx_reflections_session` ON `reflections` (`session_id`);--> statement-breakpoint
ALTER TABLE `activities` ADD `ends_at` integer;--> statement-breakpoint
ALTER TABLE `participants` ADD `avatar` text DEFAULT '🦊' NOT NULL;--> statement-breakpoint
ALTER TABLE `participants` ADD `team` text DEFAULT 'FIRE' NOT NULL;--> statement-breakpoint
ALTER TABLE `participants` ADD `xp` integer DEFAULT 0 NOT NULL;--> statement-breakpoint
ALTER TABLE `posts` ADD `pinned` integer DEFAULT 0 NOT NULL;--> statement-breakpoint
ALTER TABLE `sessions` ADD `anonymous_mode` text DEFAULT 'peers' NOT NULL;--> statement-breakpoint
ALTER TABLE `sessions` ADD `screen_mode` text DEFAULT 'overview' NOT NULL;