CREATE TABLE `activities` (
	`id` text PRIMARY KEY NOT NULL,
	`session_id` text NOT NULL,
	`kind` text NOT NULL,
	`prompt` text NOT NULL,
	`options` text NOT NULL,
	`answer` integer,
	`created_at` integer NOT NULL,
	FOREIGN KEY (`session_id`) REFERENCES `sessions`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `idx_activities_session` ON `activities` (`session_id`);--> statement-breakpoint
CREATE TABLE `participants` (
	`id` text PRIMARY KEY NOT NULL,
	`session_id` text NOT NULL,
	`name` text NOT NULL,
	`token` text NOT NULL,
	`joined_at` integer NOT NULL,
	FOREIGN KEY (`session_id`) REFERENCES `sessions`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `participants_token_unique` ON `participants` (`token`);--> statement-breakpoint
CREATE INDEX `idx_participants_session` ON `participants` (`session_id`);--> statement-breakpoint
CREATE TABLE `posts` (
	`id` text PRIMARY KEY NOT NULL,
	`session_id` text NOT NULL,
	`participant_id` text NOT NULL,
	`kind` text NOT NULL,
	`body` text NOT NULL,
	`hidden` integer DEFAULT 0 NOT NULL,
	`likes` integer DEFAULT 0 NOT NULL,
	`created_at` integer NOT NULL,
	FOREIGN KEY (`session_id`) REFERENCES `sessions`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`participant_id`) REFERENCES `participants`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `idx_posts_session_created` ON `posts` (`session_id`,`created_at`);--> statement-breakpoint
CREATE TABLE `responses` (
	`id` text PRIMARY KEY NOT NULL,
	`activity_id` text NOT NULL,
	`participant_id` text NOT NULL,
	`option_index` integer NOT NULL,
	`created_at` integer NOT NULL,
	FOREIGN KEY (`activity_id`) REFERENCES `activities`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`participant_id`) REFERENCES `participants`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `idx_responses_activity` ON `responses` (`activity_id`);--> statement-breakpoint
CREATE INDEX `idx_responses_participant_activity` ON `responses` (`participant_id`,`activity_id`);--> statement-breakpoint
CREATE TABLE `sessions` (
	`id` text PRIMARY KEY NOT NULL,
	`title` text NOT NULL,
	`code` text NOT NULL,
	`teacher_token` text NOT NULL,
	`status` text DEFAULT 'live' NOT NULL,
	`activity_id` text,
	`created_at` integer NOT NULL
);
--> statement-breakpoint
CREATE UNIQUE INDEX `sessions_code_unique` ON `sessions` (`code`);