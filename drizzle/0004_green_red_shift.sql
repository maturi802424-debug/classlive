DROP INDEX `idx_responses_participant_activity`;--> statement-breakpoint
CREATE UNIQUE INDEX `uniq_responses_participant_activity` ON `responses` (`participant_id`,`activity_id`);--> statement-breakpoint
CREATE UNIQUE INDEX `uniq_likes_post_participant` ON `likes` (`post_id`,`participant_id`);--> statement-breakpoint
CREATE UNIQUE INDEX `uniq_reflections_session_participant` ON `reflections` (`session_id`,`participant_id`);--> statement-breakpoint
CREATE UNIQUE INDEX `uniq_reports_post_participant` ON `reports` (`post_id`,`participant_id`);