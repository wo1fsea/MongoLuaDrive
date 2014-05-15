-- package --
local P = {}
if _REQUIREDNAME == nil then
	Bson = P
else
	_G[_REQUIREDNAME] = P
end


-- key 4 real table --
local __magicKey = {}

-- Bson NULL Value --
local __NULL = {}

--key 4 Bson type --
local __type = {}


-- type --
local __typeUnused = {}
local __typeArray = {}
local __typeBsonDoc = {}

local __typeRegex = {}

local __typeDateTime = {}
local __typeTimeStamp = {}

local __typeString = {}

local __typeDouble = {}
local __typeInt32 = {}
local __typeInt64 = {}


--[[
typedef enum
{
   BSON_TYPE_EOD = 0x00,
   BSON_TYPE_DOUBLE = 0x01,
   BSON_TYPE_UTF8 = 0x02,
   BSON_TYPE_DOCUMENT = 0x03,
   BSON_TYPE_ARRAY = 0x04,
   BSON_TYPE_BINARY = 0x05,
   BSON_TYPE_UNDEFINED = 0x06,
   BSON_TYPE_OID = 0x07,
   BSON_TYPE_BOOL = 0x08,
   BSON_TYPE_DATE_TIME = 0x09,
   BSON_TYPE_NULL = 0x0A,
   BSON_TYPE_REGEX = 0x0B,
   BSON_TYPE_DBPOINTER = 0x0C,
   BSON_TYPE_CODE = 0x0D,
   BSON_TYPE_SYMBOL = 0x0E,
   BSON_TYPE_CODEWSCOPE = 0x0F,
   BSON_TYPE_INT32 = 0x10,
   BSON_TYPE_TIMESTAMP = 0x11,
   BSON_TYPE_INT64 = 0x12,
   BSON_TYPE_MAXKEY = 0x7F,
   BSON_TYPE_MINKEY = 0xFF,
} bson_type_t; 
]]--


-- Bson metatable --
local mt = {}


-- __index --
--
-- DESCRIPTION
-- __index function 4 Bson metatable
-- When Bson Object is a table, it will take string keys only; when it is an arrary, it will take number keys only.
--
-- RETURN
-- Bson value
--
-- ERROR
-- If the parameter is a wrong type or the key does not exist, error() will be called.
--
-- --

mt.__index = function (bson,k)
	if bson[__type] == __typeArray and type(k) ~= "number" then
		error("Only number keys can be used in an arrary.")
	elseif bson[__type] == __typeBsonDoc and type(k) ~= "string" then
		error("Only string keys can be used in a BSON document.")
	end

	-- * MARK: SPECIAL PROCESS 4 NUMBER WRAPPER SHALL BE ADD. * --

	local value = bson[__magicKey][k]
	if value == nil then
		error("The key does not exist.")
	elseif value == __NULL then
		return nil
	else
		return value
	end
end


-- __newindex --
--
-- DESCRIPTION
-- __newindex function 4 Bson metatable
-- When Bson Object is a table, it will take string keys only; when it is an arrary, it will take number keys only.
--
-- RETURN
-- nil
--
-- ERROR
-- If the parameter is a wrong type, error() will be called.
--
-- --

mt.__newindex = function(bson,k,v)
	if bson[__type] == __typeArray and type(k) ~= "number" then
		error("Only number keys can be used in an arrary.")
	elseif bson[__type] == __typeBsonDoc and type(k) ~= "string" then
		error("Only string keys can be used in a BSON document.")
	elseif bson[__type] == __typeUnused then
		if type(k) == "number" then
			bson[__type] = __typeArray
		elseif type(k) == "string" then
			bson[__type] =	__typeBsonDoc
		else
			error("Only string/number keys can be used.")
		end
	end

	-- * MARK: SPECIAL PROCESS 4 NUMBER WRAPPER SHALL BE ADD. * --

	if v == nil then
		v = __NULL
	end

	bson[__magicKey][k] = v;
end

-- P.New --
--
-- DESCRIPTION
-- ctor function
-- This function shall construct a Bson object from a table/arrary.
-- The parameter has to be a table which only has string keys, or an arrary which only has number keys.
--
-- RETURN
-- return a Bson object.
--
-- ERROR
-- If the parameter is a wrong type, error() will be called.
-- --

P.New = function(t)
	-- data table --
	local __data = {}
	local selfType = __typeUnused

	-- 4 the initialization parameter --
	if t then
		-- not table/arrary --
		if type(t) ~= "table" then
			error("The initialization parameter is not a table/arrary.")
		end

		for k,v in pairs(t) do
			local tmp = type(k)
			if tmp == "number" then
				selfType = __typeArray
			elseif tmp == "string" then
				selfType = __typeBsonDoc
			else
				error("The initialization parameter must be either a table or an arrary.")
			end
			break
		end

		local numn = 0
		for k,v in pairs(t) do
			local tmp = type(k)
			numn = numn + 1
			if tmp == "string" and selfType == __typeBsonDoc
				or tmp == "number" and selfType == __typeArray then
				__data[k] = v
			else
				error("The initialization parameter must be either a table or an arrary.")
			end
		end

	end

	-- self --
	local self = {}
	self[__type] = selfType
	self[__magicKey] = __data
	setmetatable(self, mt)
	return self
end


-- test --
--[[
a = {}
c = {c=1,a=6,d=100}
test = Bson.New(c)
test[1] = 7
print(test["d"])
]]
