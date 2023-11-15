local common = require("common")
local JSON = require("json")
local params = arg
assert(params[1], "No token file given!")
local tokenizedFile = JSON.decode(io.open(params[1], "r"):read("a"))
-------- Parsing --------
local expressions = JSON.decode(io.open("grammar.json", "r"):read("a")).grammar
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