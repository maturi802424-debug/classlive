CREATE TABLE `reports` (
	`id` text PRIMARY KEY NOT NULL,
	`session_id` text NOT NULL,
	`post_id` text NOT NULL,
	`participant_id` text NOT NULL,
	`created_at` integer NOT NULL,
	FOREIGN KEY (`session_id`) REFERENCES `sessions`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`post_id`) REFERENCES `posts`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`participant_id`) REFERENCES `participants`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `idx_reports_session` ON `reports` (`session_id`);