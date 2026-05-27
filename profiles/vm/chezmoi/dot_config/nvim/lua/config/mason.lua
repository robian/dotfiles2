local packages = {
	-- lua
	"lua-language-server",
	"stylua",
	-- python
	"ruff",
	"pyright",
	-- typescript
	"biome",
	"vtsls",
	"tailwindcss-language-server",
}

local function contains(list, value)
	return vim.tbl_contains(list, value)
end

local function notify(message, level)
	vim.schedule(function()
		vim.notify(message, level)
	end)
end

local function needs_install(pkg, name)
	if not pkg:is_installed() then
		return true
	end

	local has_receipt = pkg:get_receipt():is_present()
	if not has_receipt then
		notify(("mason: %s is installed without a receipt; leaving it in place"):format(name), vim.log.levels.WARN)
	end

	return false
end

local function notify_done(action, name)
	return function(success, error)
		if success then
			notify(("mason: %s %s"):format(action, name), vim.log.levels.INFO)
		else
			notify(("mason: failed to %s %s: %s"):format(action, name, error), vim.log.levels.ERROR)
		end
	end
end

require("mason").setup()

local registry = require("mason-registry")
registry.refresh(function(success)
	if not success then
		notify("mason: failed to refresh registry", vim.log.levels.WARN)
		return
	end

	for _, name in ipairs(packages) do
		local pkg = registry.get_package(name)
		local should_install = needs_install(pkg, name)
		if should_install then
			notify(("mason: installing %s"):format(name), vim.log.levels.INFO)
			pkg:install({}, notify_done("installed", name))
		end
	end

	for _, name in ipairs(registry.get_installed_package_names()) do
		if not contains(packages, name) and registry.has_package(name) then
			notify(("mason: uninstalling %s"):format(name), vim.log.levels.INFO)
			registry.get_package(name):uninstall({}, notify_done("uninstalled", name))
		end
	end
end)
