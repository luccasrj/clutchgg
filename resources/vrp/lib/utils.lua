SERVER = IsDuplicityVersion()
CLIENT = not SERVER
-----------------------------------------------------------------------------------------------------------------------------------------
-- TABLE.MAXN
-----------------------------------------------------------------------------------------------------------------------------------------
function table.maxn(t)
	local max = 0

	for k,v in pairs(t) do
		local n = tonumber(k)
		if n and n > max then
			max = n
		end
	end

	return max
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MODULE
-----------------------------------------------------------------------------------------------------------------------------------------
local modules = {}
function module(resource,patchs)
	if patchs == nil or not patchs then
		patchs = resource
		resource = "vrp"
	end

	local key = resource..patchs
	local checkModule = modules[key]
	if checkModule then
		return checkModule
	else
		local code = LoadResourceFile(resource,patchs..".lua")
		if code then
			local floats = load(code,resource.."/"..patchs..".lua")
			if floats then
				local resAccept,resUlts = xpcall(floats,debug.traceback)
				if resAccept then
					modules[key] = resUlts
					return resUlts
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WAIT
-----------------------------------------------------------------------------------------------------------------------------------------
local function wait(self)
	local rets = Citizen.Await(self.p)
	if not rets then
		rets = self.r
	end

	return table.unpack(rets,1,table.maxn(rets))
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ARETURN
-----------------------------------------------------------------------------------------------------------------------------------------
local function areturn(self,...)
	self.r = {...}
	self.p:resolve(self.r)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ASYNC
-----------------------------------------------------------------------------------------------------------------------------------------
function async(func)
	if func then
		Citizen.CreateThreadNow(func)
	else
		return setmetatable({ wait = wait, p = promise.new() }, { __call = areturn })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARSEINT
-----------------------------------------------------------------------------------------------------------------------------------------
function parseInt(v)
	local n = tonumber(v)
	if n == nil then
		return 0
	else
		return math.floor(n)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SANITIZESTRING
-----------------------------------------------------------------------------------------------------------------------------------------
local sanitize_tmp = {}
function sanitizeString(str,strchars,allow_policy)
	local r = ""
	local chars = sanitize_tmp[strchars]
	if chars == nil then
		chars = {}
		local size = string.len(strchars)
		for i = 1,size do
			local char = string.sub(strchars,i,i)
			chars[char] = true
		end

		sanitize_tmp[strchars] = chars
	end

	size = string.len(str)
	for i = 1,size do
		local char = string.sub(str,i,i)
		if (allow_policy and chars[char]) or (not allow_policy and not chars[char]) then
			r = r..char
		end
	end

	return r
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPLITSTRING
-----------------------------------------------------------------------------------------------------------------------------------------
function splitString(str,symbol)
	local number = 1
	local tableResult = {}

	if symbol == nil then
		symbol = "-"
	end

	for str in string.gmatch(str,"([^"..symbol.."]+)") do
		tableResult[number] = str
		number = number + 1
	end

	return tableResult
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MATHLEGTH
-----------------------------------------------------------------------------------------------------------------------------------------
function mathLength(n)
	return math.ceil(n * 100) / 100
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARSEFORMAT
-----------------------------------------------------------------------------------------------------------------------------------------
function parseFormat(number)
	local left,num,right = string.match(parseInt(number),"^([^%d]*%d)(%d*)(.-)$")
	return left..(num:reverse():gsub("(%d%d%d)","%1."):reverse())..right
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FULLTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
function fullTimers(seconds)
    local days = math.floor(seconds/86400)
    seconds = seconds - days * 86400
    local hours = math.floor(seconds/3600)

    if days > 0 then
        return string.format("<b>%d Dias</b> e <b>%d Horas</b>",days,hours)
    else
        return string.format("<b>%d Horas</b>",hours)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMPLETETIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
function completeTimers(seconds)
	local days = math.floor(seconds / 86400)
	seconds = seconds - days * 86400
	local hours = math.floor(seconds / 3600)
	seconds = seconds - hours * 3600
	local minutes = math.floor(seconds / 60)
	seconds = seconds - minutes * 60

	if days > 0 then
		return string.format("<b>%d Dias</b>, <b>%d Horas</b>, <b>%d Minutos</b> e <b>%d Segundos</b>",days,hours,minutes,seconds)
	elseif hours > 0 then
		return string.format("<b>%d Horas</b>, <b>%d Minutos</b> e <b>%d Segundos</b>",hours,minutes,seconds)
	elseif minutes > 0 then
		return string.format("<b>%d Minutos</b> e <b>%d Segundos</b>",minutes,seconds)
	elseif seconds > 0 then
		return string.format("<b>%d Segundos</b>",seconds)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MINIMALTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
function minimalTimers(seconds)
	local days = math.floor(seconds / 86400)
	seconds = seconds - days * 86400
	local hours = math.floor(seconds / 3600)
	seconds = seconds - hours * 3600
	local minutes = math.floor(seconds / 60)
	seconds = seconds - minutes * 60

	if days > 0 then
		return string.format("%d Dias, %d Horas",days,hours)
	elseif hours > 0 then
		return string.format("%d Horas, %d Minutos",hours,minutes)
	elseif minutes > 0 then
		return string.format("%d Minutos",minutes)
	elseif seconds > 0 then
		return string.format("%d Segundos",seconds)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INV_RANGE
-----------------------------------------------------------------------------------------------------------------------------------------
function inv_range(to)
	local cur = 0
	to = to or 100
	return function()
		cur = cur + 1
		if cur <= to then 
			return tostring(cur)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAIRS
-----------------------------------------------------------------------------------------------------------------------------------------
function spairs(t, order)
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

	local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end