require('vgit').setup({
	keymaps = {
		['n [h'] = 'hunk_up',
		['n ]h'] = 'hunk_down',
		['n <leader>gs'] = 'buffer_hunk_stage',
		['n <leader>gr'] = 'buffer_hunk_reset',
		['n <leader>gp'] = 'buffer_hunk_preview',
		['n <leader>gb'] = 'buffer_blame_preview',
		['n <leader>gf'] = 'buffer_diff_preview',
		['n <leader>gh'] = 'buffer_history_preview',
		['n <leader>gu'] = 'buffer_reset',
		['n <leader>gg'] = 'buffer_gutter_blame_preview',
		['n <leader>gl'] = 'project_hunks_preview',
		['n <leader>gd'] = 'project_diff_preview',
		['n <leader>gq'] = 'project_hunks_qf',
		['n <leader>gx'] = 'toggle_diff_preference',
	},
	settings = {
		live_blame = {
			enabled = true,
			format = function(blame, git_config)
				local config_author = git_config['user.name']
				local author = blame.author
				if config_author == author then
					author = 'You'
				end
				local time = os.difftime(os.time(), blame.author_time)
				    / (60 * 60 * 24 * 30 * 12)
				local time_divisions = {
					{ 1, 'years' },
					{ 12, 'months' },
					{ 30, 'days' },
					{ 24, 'hours' },
					{ 60, 'minutes' },
					{ 60, 'seconds' },
				}
				local counter = 1
				local time_division = time_divisions[counter]
				local time_boundary = time_division[1]
				local time_postfix = time_division[2]
				while time < 1 and counter ~= #time_divisions do
					time_division = time_divisions[counter]
					time_boundary = time_division[1]
					time_postfix = time_division[2]
					time = time * time_boundary
					counter = counter + 1
				end
				local commit_message = blame.commit_message
				if not blame.committed then
					author = 'You'
					commit_message = 'Uncommitted changes'
					return string.format(' %s ? %s', author, commit_message)
				end
				local max_commit_message_length = 255
				if #commit_message > max_commit_message_length then
					commit_message = commit_message:sub(1, max_commit_message_length) .. '...'
				end
				return string.format(
					' %s, %s ? %s',
					author,
					string.format(
						'%s %s ago',
						time >= 0 and math.floor(time + 0.5) or math.ceil(time - 0.5),
						time_postfix
					),
					commit_message
				)
			end,
		},
		authorship_code_lens = {
			enabled = false,
		},
		live_gutter = {
			enabled = true,
		},
		screen = {
			diff_preference = 'unified',
		},
		project_diff_preview = {
			keymaps = {
				buffer_stage = 's',
				buffer_unstage = 'u',
				stage_all = 'a',
				unstage_all = 'd',
				reset_all = 'r',
			},
		},
	}
})
