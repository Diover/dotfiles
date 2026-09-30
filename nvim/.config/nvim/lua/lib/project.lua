local M = {}
local _cache = nil

function M.load(source)
	if _cache then
		return _cache
	end
	local root = vim.fs.root(source or 0, function(_, path)
		return vim.uv.fs_stat(path .. "/.nvim/project.json") ~= nil
	end)
	if not root then
		return nil
	end
	local path = root .. "/.nvim/project.json"
	local f = io.open(path, "r")
	if not f then
		return nil
	end
	local content = f:read("*a")
	f:close()
	local ok, data = pcall(vim.json.decode, content)
	if not ok then
		return nil
	end
	_cache = { root = root, modules = data.modules or {} }
	return _cache
end

function M.find_module_root(bufpath)
	local project = M.load(bufpath)
	if not project or #project.modules == 0 then
		return nil
	end
	local norm_buf = vim.fs.normalize(bufpath)
	local best = nil
	for _, mod in ipairs(project.modules) do
		local mod_path = vim.fs.normalize(project.root .. "/" .. mod)
		if norm_buf:sub(1, #mod_path + 1) == mod_path .. "/" then
			if not best or #mod_path > #best then
				best = mod_path
			end
		end
	end
	return best
end

function M.make_root_dir(fallback_markers)
	return function(bufnr, on_dir)
		local bufname = vim.api.nvim_buf_get_name(bufnr)
		if bufname == "" then
			return
		end
		local module_root = M.find_module_root(bufname)
		if module_root then
			on_dir(module_root)
			return
		end
		local root = vim.fs.root(bufnr, fallback_markers)
		if root then
			on_dir(root)
		end
	end
end

function M.invalidate()
	_cache = nil
end

return M
