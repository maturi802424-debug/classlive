CREATE TABLE `ai_requests` (
	`id` text PRIMARY KEY NOT NULL,
	`session_id` text NOT NULL,
	`actor_id` text NOT NULL,
	`kind` text NOT NULL,
	`created_at` integer NOT NULL,
	FOREIGN KEY (`session_id`) REFERENCES `sessions`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `idx_ai_requests_session_actor_kind_time` ON `ai_requests` (`session_id`,`actor_id`,`kind`,`created_at`);