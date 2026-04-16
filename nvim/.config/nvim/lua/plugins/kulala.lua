return {
	"mistweaverco/kulala.nvim",
	opts = {
		global_keymaps = false,
		kulala_keymaps = true,
		default_env = "dev",
		split_direction = "vertical",
		default_view = "body",
	},
	config = function(_, opts)
		require("kulala").setup(opts)

		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "http", "rest" },
			callback = function(ev)
				local kulala = require("kulala")
				local buf = ev.buf
				local function bmap(key, fn, desc)
					vim.keymap.set("n", key, fn, { buffer = buf, desc = desc })
				end

				-- Request execution
				bmap("<leader>vr", kulala.run, "HTTP [R]un request")
				bmap("<leader>va", kulala.run_all, "HTTP Run [A]ll requests")
				bmap("<leader>vx", function()
					require("kulala.ui").interrupt_requests()
				end, "HTTP Stop request [X]")

				-- Environment
				bmap("<leader>ve", kulala.set_selected_env, "HTTP Set [E]nvironment")

				-- Inspection & debug
				bmap("<leader>vd", kulala.inspect, "HTTP [D]ry run / inspect")
				bmap("<leader>vv", function()
					require("kulala.ui").show_verbose()
				end, "HTTP Show [V]erbose")
				bmap("<leader>vs", kulala.show_stats, "HTTP Show [S]tats")
				bmap("<leader>vt", kulala.toggle_view, "HTTP [T]oggle headers/body")

				-- Copy & paste
				bmap("<leader>vc", kulala.copy, "HTTP [C]opy as cURL")
				bmap("<leader>vC", kulala.from_curl, "HTTP Paste from [C]url")

				-- Navigation
				bmap("<leader>vn", kulala.jump_next, "HTTP [N]ext request")
				bmap("<leader>vp", kulala.jump_prev, "HTTP [P]rev request")
				bmap("<leader>vf", kulala.search, "HTTP [F]ind request")

				-- Replay & cache
				bmap("<leader>vR", kulala.replay, "HTTP [R]eplay last request")
				bmap("<leader>vX", kulala.clear_cached_files, "HTTP Clear cached files [X]")

				-- Cookies & auth
				bmap("<leader>vj", kulala.open_cookies_jar, "HTTP Cookies [J]ar")
				bmap("<leader>vu", function()
					require("kulala.ui.auth_manager").open_auth_config()
				end, "HTTP A[U]th config")

				-- Windows
				bmap("<leader>vo", kulala.open, "HTTP [O]pen kulala")
				bmap("<leader>vq", kulala.close, "HTTP [Q]uit window")
				bmap("<leader>vb", kulala.scratchpad, "HTTP Scratch[B]pad")
			end,
		})

		-- which-key group
		local ok, which_key = pcall(require, "which-key")
		if ok then
			which_key.add({
				{ "<leader>v", group = "HTTP requests" },
			})
		end
	end,
}
