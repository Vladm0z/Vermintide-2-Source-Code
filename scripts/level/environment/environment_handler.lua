-- chunkname: @scripts/level/environment/environment_handler.lua

require("scripts/level/environment/environment_blend_time")
require("scripts/level/environment/environment_blend_volume")

EnvironmentHandler = class(EnvironmentHandler)

local EnvironmentHandler = EnvironmentHandler
local ID = EnvironmentHandler.ID

ID = ID or 0
EnvironmentHandler.ID = ID

EnvironmentHandler.init = function (self)
	-- function 1
	self._blends = {}
	self._weights = {}
end

EnvironmentHandler.add_blend_group = function (arg_2_0, arg_2_1)
	-- function 2
	arg_2_0._blends[arg_2_1] = {}
end

EnvironmentHandler.add_blend = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	local var_3_0

	if not arg_3_5 then
		var_3_0 = arg_3_5
	else
		EnvironmentHandler.ID = EnvironmentHandler.ID + 1
		var_3_0 = EnvironmentHandler.ID
	end

	local var_3_1 = rawget(_G, arg_3_1):new(arg_3_4)
	local var_3_2 = self._blends[arg_3_2]

	var_3_2[#var_3_2 + 1] = {
		priority = arg_3_3,
		blend = var_3_1,
		id = var_3_0
	}

	table.sort(var_3_2, function (self, arg_4_1)
		-- function 4
		return self.priority > arg_4_1.priority
	end)

	return var_3_0
end

EnvironmentHandler.remove_blend = function (self, arg_5_1)
	-- function 5
	for k, v in pairs(self._blends) do
		for k_2, v_2 in pairs(v) do
			if v_2.id == arg_5_1 then
				v_2.blend:destroy()
				table.remove(v, k_2)
				table.clear(self._weights)
				self:_update_weights()

				return
			end
		end
	end
end

EnvironmentHandler.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	self:_update_blends(arg_6_1)
	self:_update_weights(arg_6_1)
end

EnvironmentHandler._update_blends = function (self, arg_7_1)
	-- function 7
	for k, v in pairs(self._blends) do
		for i, v_2 in ipairs(v) do
			v_2.blend:update(arg_7_1)
		end
	end
end

EnvironmentHandler._update_weights = function (self)
	-- function 8
	local var_8_0

	for k, v in pairs(self._blends) do
		local var_8_1 = self._weights[k]

		var_8_1 = var_8_1 or {}

		local num = 1
		local num_2 = 1

		for k_2 = 1, #v do
			local var_8_4 = v[k_2]

			if not var_8_1[k_2] then
				local tbl = {}
			end

			local flag = var_8_1[k_2] or {}

			flag.environment = var_8_4.blend:environment()
			flag.blend = var_8_4.blend
			flag.particle_light_intensity = var_8_4.blend:particle_light_intensity()

			if num > 0 then
				local min = math.min(var_8_4.blend:value(), num)

				flag.weight = min
				num = num - min
			else
				flag.weight = 0
			end

			var_8_1[k_2] = flag
			k_2 = k_2 + 1
		end

		self._weights[k] = var_8_1
	end
end

EnvironmentHandler.weights = function (self, arg_9_1)
	-- function 9
	return self._weights[arg_9_1]
end

EnvironmentHandler.override_settings = function (self)
	-- function 10
	local num = 0
	local var_10_1

	for k, v in pairs(self._blends.volumes) do
		if not (not v.blend:is_inside() and not (num < v.priority)) then
			var_10_1 = v.blend
			num = v.priority
		end
	end

	if not var_10_1 then
		return var_10_1:override_settings()
	end

	return nil
end

EnvironmentHandler.destroy = function (self)
	-- function 11
	for k, v in pairs(self._blends) do
		for i, v_2 in ipairs(v) do
			v_2.blend:destroy()
		end
	end

	self._blends = nil
end
