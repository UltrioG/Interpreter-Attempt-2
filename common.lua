--- Prepares strings for printing.
--- @param s string The string to be formatted.
--- @return string
local function sanitizeString(s)
	local x = s:gsub("\\", "\\\\")
	return x
end

--- Returns a new table identical to the given table.
--- @generic TableType : table
--- @param T TableType
--- @return TableType
local function shallowCopyTable(T)
	if type(T) ~= "table" then return T end
	local new = {}
	for k, v in pairs(T) do
		new[k] = shallowCopyTable(v)
	end
	return new
end