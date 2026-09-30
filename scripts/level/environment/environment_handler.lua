-- chunkname: @scripts/level/environment/environment_handler.lua

require("scripts/level/environment/environment_blend_time")
require("scripts/level/environment/environment_blend_volume")

EnvironmentHandler = class(EnvironmentHandler)
EnvironmentHandler.ID = EnvironmentHandler.ID

EnvironmentHandler.init = function (self)
	-- function 1
	self._blends = {}
	self._weights = {}
end

EnvironmentHandler.add_blend_group = function (self, group)
	-- function 2
	self._blends[group] = {}
end

EnvironmentHandler.add_blend = function (self, blend_class_name, group, priority, blend_data, specified_id)
	-- function 3
	local id

	if specified_id then
		id = specified_id
	else
		EnvironmentHandler.ID = EnvironmentHandler.ID + 1
		id = EnvironmentHandler.ID
	end

	local blend_class = rawget(_G, blend_class_name)
	local blend = blend_class:new(blend_data)
	local group = self._blends[group]

	group[#group + 1] = {
		priority = priority,
		blend = blend,
		id = id
	}

	table.sort(group, function (a, b)
		-- function 4
		return a.priority > b.priority
	end)

	return id
end

EnvironmentHandler.remove_blend = function (self, id)
	-- function 5
	for _, group in pairs(self._blends) do
		for key, blend_data in pairs(group) do
			if blend_data.id == id then
				blend_data.blend:destroy()
				table.remove(group, key)
				table.clear(self._weights)
				self:_update_weights()

				return
			end
		end
	end
end

EnvironmentHandler.update = function (self, dt, t)
	-- function 6
	self:_update_blends(dt)
	self:_update_weights(dt)
end

EnvironmentHandler._update_blends = function (self, dt)
	-- function 7
	for _, blends in pairs(self._blends) do
		for _, b in ipairs(blends) do
			b.blend:update(dt)
		end
	end
end

EnvironmentHandler._update_weights = function (self)
	-- function 8
	local particle_light_intensity

	for group, blends in pairs(self._blends) do
		local weights = self._weights[group]
		local weight_pool = 1
		local i = 1

		for i = 1, #blends do
			local b = blends[i]
			local weight_data = weights[i]

			weight_data = weights[i] or {}
			weight_data.environment = b.blend:environment()
			weight_data.blend = b.blend
			weight_data.particle_light_intensity = b.blend:particle_light_intensity()

			if weight_pool > 0 then
				local weight = math.min(b.blend:value(), weight_pool)

				weight_data.weight = weight
				weight_pool = weight_pool - weight
			else
				weight_data.weight = 0
			end

			weights[i] = weight_data
			i = i + 1
		end

		self._weights[group] = weights
	end
end

EnvironmentHandler.weights = function (self, group)
	-- function 9
	return self._weights[group]
end

EnvironmentHandler.override_settings = function (self)
	-- function 10
	local max_prio = 0
	local blend_volume

	for i, blend in pairs(self._blends.volumes) do
		if blend.blend:is_inside() and max_prio < blend.priority then
			blend_volume = blend.blend
			max_prio = blend.priority
		end
	end

	if blend_volume then
		return blend_volume:override_settings()
	end

	return nil
end

EnvironmentHandler.destroy = function (self)
	-- function 11
	for _, blends in pairs(self._blends) do
		for _, b in ipairs(blends) do
			b.blend:destroy()
		end
	end

	self._blends = nil
end
