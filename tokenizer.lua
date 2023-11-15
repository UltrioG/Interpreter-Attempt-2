-------- Libraries --------
local JSON = require("json")
local common = require("common")
assert(io.open("grammar.json", "r"), "No grammar json file found!")

-------- Constant Definition --------
local grammarJson = JSON.decode(io.open("grammar.json", "r"):read("a"))
--- The tokens to be used for tokenization
--- @alias tokenList {[1]: string, [2]: string[]}[]
--- @alias tokenizedList {[1]: string, [2]: string}[]
--- @alias expressionSymbol string | {[1]: string} | {[1]: string, [2]: string}
--- @alias expressionList {[string]: expressionSymbol[][]}
--- @type tokenList
local tokens = grammarJson.tokens
--- ## Expression List
--- The list of expressions this program has.<br>
--- An expression is a list of possibilities for the expression's form.<br>
--- For example, an algebraic expression would be something like
--- `EXP = {{{"number"}, {"operator"}, "EXP"}}`.<br>
--- Note that `"..."` as an expressionSymbol means that the previous symbol is repeated indefinitely.
--- @type expressionList
local expressions = grammarJson.grammar


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

local tokenizedJsonFile = io.open("tokenJson.json", "w+")
tokenizedJsonFile:write(JSON.encode(tokenizedFile))