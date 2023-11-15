-------- Constant Definition --------
--- The tokens to be used for tokenization
--- @alias tokenList {[1]: string, [2]: string[]}[]
--- @alias tokenizedList {[1]: string, [2]: string}[]
--- @alias expressionSymbol string | {[1]: string} | {[1]: string, [2]: string}
--- @alias expressionList {[string]: expressionSymbol[][]}
--- @type tokenList
local tokens = {
	{"commentInitalizer", {"#"}},
	{"keySymbols", {"\\", "λ", "%.", ":=", "%^", "%(", "%)"}},
	{"identifier", {"[%w_]*"}},
	{"whitespace", {"%s+"}},
}
--- ## Expression List
--- The list of expressions this program has.<br>
--- An expression is a list of possibilities for the expression's form.<br>
--- For example, an algebraic expression would be something like
--- `EXP = {{{"number"}, {"operator"}, "EXP"}}`.<br>
--- Note that `"..."` as an expressionSymbol means that the previous symbol is repeated indefinitely.
--- @type expressionList
local expressions = {
	PROGRAM = {
		{"Expression", "..."}
	},
	Expression = {
		{"Assignment"},
		{"WriteExpression"}
	},
	Value = {
		{"LambdaDefinition"},
		{{"identifier"}}
	},
	LambdaDefinition = {
		{"LambdaBinding", "Value"},
	},
	WriteExpression = {
		{{"keySymbols", "^"}, "Value"}
	},
	LambdaBinding = {
		{{"keySymbols", "\\"}, {"identifier"}, {"keySymbols", "."}},
		{{"keySymbols", "λ"}, {"identifier"}, {"keySymbols", "."}},
	}
}

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

-------- File Setup --------

local runArgs = arg

--- Opens a file and returns it.
--- Has error checking built in.
--- @param filename string The name of the file to be opened, with file extension.
--- @return file*
local function openFile(filename)
	local fileToOpen = filename
	if not fileToOpen then
		error("Real time interpreter is not currently implemented. Exiting operation.")
	end
	if fileToOpen:match("%.%w+$"):lower() ~= ".luda" then
		error(("File \"%s\" has extension type \"%s\" while it's supposed to have filetype \".luda\"!"):format(fileToOpen, fileToOpen:match("%.%w+$")))
	end
	local file = io.open(fileToOpen, "r")
	if not file then
		error(("File \"%s\" does not exist!"):format(fileToOpen))
	end
	return file
end

local file = openFile(runArgs[1])
local fileStr = file:read("a")

-------- Tokenization --------

--- Tokenizes a string based on the given tokens.
--- @param fileStr string The string to be tokenized.
--- @param tokens tokenList The token list.
--- @return tokenizedList
local function tokenizeStr(fileStr, tokens)
	local tokenizedFile = {}
	local fileStrCache = fileStr
	local lastFileStrCache = fileStrCache
	repeat
		local matched = false
		for _, tokenObject in ipairs(tokens) do
			for _, tokenPattern in ipairs(tokenObject[2]) do
				local match = fileStrCache:match("^"..tokenPattern)
				if match then
					--- @cast match string
					matched = true
					table.insert(tokenizedFile, {tokenObject[1], match})
					fileStrCache = fileStrCache:sub(1+#match, -1)
					break
				end
				if matched then break end
			end
		end
		if not matched then
			error(("Unidentified symbol \"%s\"!"):format(fileStrCache:match("^%S+")))
		end
		if lastFileStrCache == fileStrCache then
			error(("No change detected, some sort of infinite loop is going on."))
		end
	until fileStrCache == ""
	return tokenizedFile
end

local tokenizedFile = tokenizeStr(fileStr, tokens)

for _, v in ipairs(tokenizedFile) do print(v[1], v[2]) end

-------- Parsing --------

do
--- Checks if a given token list matches a given expression type
--- @param tokens tokenizedList
--- @param expression string
--- @param expressions expressionList
--- @return boolean
-- local function verifyIsExpression(tokens, expression, expressions)
-- 	local isValid = true
-- 	local tokenCache = shallowCopyTable(tokens)
	
-- 	repeat
		
-- 	until 

-- 	return isValid
-- end
end

--- An arbitrary tree.
--- @class Tree
--- @field value any
--- @field children Tree[]
local Tree = {
	value = nil,
	children = {}
}
Tree.__index = Tree
--- @alias Node Tree
--- @class Tree
local Node = Tree

do
	--- Constructs a root node with the given value.
	---@param value any
	---@return Tree
	function Node:new(value)
		--- @type Tree
		local new = {
			children = self.children or {},
			value = value
		}
		setmetatable(new, self)
		return new
	end

	--- Adds a child to the given node.
	--- @generic T
	--- @param value T
	--- @param position integer?
	--- @return Node
	function Node:addChild(value, position)
		local node = Node:new(value)
		table.insert(self.children, position and position or value, position)
		return node
	end

	--- Adds children to the given node in a functional manner. I.e.,<br>
	--- `Node:addChildren(2)(3)(5)` means the Node now has 3 more children of values 2, 3 and 5.
	--- @overload fun(): nil
	--- @param value any
	--- @return function
	function Node:addChildren(value)
		if value == nil then return end
		self:addChild(value)
		return function (v) self:addChildren(v) end
	end
end

--- Turns tokens into an AST.
---@param tokenList tokenizedList
---@param expressions expressionList
---@diagnostic disable-next-line: redefined-local
local function parseTokens(tokenList, expressions)
	
end

local parsedFile = parseTokens(tokenizedFile, expressions)