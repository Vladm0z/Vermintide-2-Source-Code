-- chunkname: @scripts/entity_system/systems/ai/ai_panic_system.lua

require("scripts/unit_extensions/human/ai_player_unit/ai_utils")

local tbl = {
	"AIPanicExtension",
	"AIFearExtension"
}

AIPanicSystem = class(AIPanicSystem, ExtensionSystemBase)

AIPanicSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	local entity_manager = arg_1_1.entity_manager

	entity_manager:register_system(self, arg_1_2, tbl)

	self.entity_manager = entity_manager
	self.is_server = arg_1_1.is_server
	self.world = arg_1_1.world
	self.unit_storage = arg_1_1.unit_storage
	self.nav_world = Managers.state.entity:system("ai_system"):nav_world()
	self.unit_extension_data = {}
	self.panic_zones = {}
	self.panic_units = {}
	self.fear_units = {}
	self.panic_zone_id = 1
	self.current_fear_unit_index = 1
	self.current_panic_unit_index = 1
end

AIPanicSystem.destroy = function (arg_2_0)
	-- function 2
	return
end

local tbl_2 = {}

AIPanicSystem.on_add_extension = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local tbl = {}

	ScriptUnit.set_extension(arg_3_2, "ai_panic_system", tbl, tbl_2)

	self.unit_extension_data[arg_3_2] = tbl

	if arg_3_3 == "AIPanicExtension" then
		self.panic_units[#self.panic_units + 1] = arg_3_2
	end

	if arg_3_3 == "AIFearExtension" then
		local fear_active_on_spawn = arg_3_4.fear_active_on_spawn
		local fear_radius = arg_3_4.fear_radius

		self.fear_units[#self.fear_units + 1] = arg_3_2
		tbl.fear_radius = fear_radius

		if not fear_active_on_spawn then
			self:activate_fear(arg_3_2)
		end
	end

	return tbl
end

AIPanicSystem.on_remove_extension = function (self, arg_4_1, arg_4_2)
	-- function 4
	local var_4_0 = self.unit_extension_data[arg_4_1]

	if arg_4_2 == "AIPanicExtension" then
		local panic_units = self.panic_units
		local count = #panic_units

		for i = 1, count do
			if panic_units[i] == arg_4_1 then
				panic_units[i] = panic_units[count]
				panic_units[count] = nil

				break
			end
		end
	end

	if arg_4_2 == "AIFearExtension" then
		local fear_units = self.fear_units
		local count_2 = #fear_units

		for j = 1, count_2 do
			if fear_units[j] == arg_4_1 then
				local panic_zone = self.unit_extension_data[arg_4_1].panic_zone

				if not panic_zone then
					self:deregister_panic_zone(panic_zone)
				end

				fear_units[j] = fear_units[count_2]
				fear_units[count_2] = nil

				break
			end
		end
	end

	self.unit_extension_data[arg_4_1] = nil

	ScriptUnit.remove_extension(arg_4_1, self.NAME)
end

AIPanicSystem.hot_join_sync = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	return
end

AIPanicSystem.activate_fear = function (self, arg_6_1)
	-- function 6
	local var_6_0 = self.unit_extension_data[arg_6_1]
	local var_6_1 = POSITION_LOOKUP[arg_6_1]
	local fear_radius = var_6_0.fear_radius

	var_6_0.panic_zone = self:register_panic_zone(var_6_1, fear_radius)
	var_6_0.active = true
end

AIPanicSystem.register_panic_zone = function (self, arg_7_1, arg_7_2)
	-- function 7
	local tbl = {
		position = Vector3Box(arg_7_1),
		radius_squared = arg_7_2 * arg_7_2,
		radius = arg_7_2
	}
	local panic_zones = self.panic_zones

	panic_zones[#panic_zones + 1] = tbl

	return tbl
end

AIPanicSystem.deregister_panic_zone = function (self, arg_8_1)
	-- function 8
	local panic_zones = self.panic_zones
	local count = #panic_zones

	for i = 1, count do
		if panic_zones[i] == arg_8_1 then
			panic_zones[i] = panic_zones[count]
			panic_zones[count] = nil

			return
		end
	end

	assert("trying to deregister_panic_zone which hasnt been registered: %q", deregister_panic_zone)
end

AIPanicSystem.set_panic_zone_position = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	arg_9_1.position:store(arg_9_2)
end

AIPanicSystem.inside_panic_zone = function (self, arg_10_1)
	-- function 10
	local panic_zones = self.panic_zones
	local count = #panic_zones

	for i = 1, count do
		repeat
			local var_10_2 = panic_zones[i]
			local unbox = var_10_2.position:unbox()

			if var_10_2.radius_squared >= Vector3.distance_squared(arg_10_1, unbox) then
				return var_10_2
			end
		until true
	end

	return nil
end

local num = 1

AIPanicSystem.update_fear_units = function (self)
	-- function 11
	local fear_units = self.fear_units
	local count = #fear_units

	if count < self.current_fear_unit_index then
		self.current_fear_unit_index = 1
	end

	local current_fear_unit_index = self.current_fear_unit_index
	local min = math.min(current_fear_unit_index + num - 1, count)

	for i = current_fear_unit_index, min do
		repeat
			local var_11_4 = fear_units[i]
			local var_11_5 = self.unit_extension_data[var_11_4]

			if not var_11_5.active then
				break
			end

			local panic_zone = var_11_5.panic_zone
			local var_11_7 = POSITION_LOOKUP[var_11_4]

			self:set_panic_zone_position(panic_zone, var_11_7)
		until true
	end

	self.current_fear_unit_index = min + 1
end

local num_2 = 1

AIPanicSystem.update_panic_units = function (self)
	-- function 12
	local panic_units = self.panic_units
	local count = #panic_units

	if count < self.current_panic_unit_index then
		self.current_panic_unit_index = 1
	end

	local current_panic_unit_index = self.current_panic_unit_index
	local min = math.min(current_panic_unit_index + num_2 - 1, count)

	for i = current_panic_unit_index, min do
		local var_12_4 = panic_units[i]
		local var_12_5 = POSITION_LOOKUP[var_12_4]
		local inside_panic_zone = self:inside_panic_zone(var_12_5)

		ScriptUnit.extension(var_12_4, "ai_system"):blackboard().panic_zone = inside_panic_zone
	end

	self.current_panic_unit_index = min + 1
end

AIPanicSystem.update = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	self:update_fear_units()
	self:update_panic_units()

	if not script_data.ai_debug_panic_zones then
		self:debug_draw_panic_zones()
	end
end

AIPanicSystem.debug_draw_panic_zones = function (self)
	-- function 14
	local drawer = Managers.state.debug:drawer({
		mode = "immediate",
		name = "AIPanicSystem"
	})
	local panic_zones = self.panic_zones
	local count = #panic_zones

	for i = 1, count do
		local var_14_3 = panic_zones[i]
		local radius = var_14_3.radius
		local unbox = var_14_3.position:unbox()

		drawer:sphere(unbox, radius, Colors.get("red"))
	end
end
