-- chunkname: @scripts/entity_system/systems/volumes/volume_system.lua

require("scripts/settings/volume_settings")
require("scripts/unit_extensions/generic/generic_volume_templates")

VolumeSystem = class(VolumeSystem, ExtensionSystemBase)

local tbl = {
	"PlayerVolumeExtension",
	"BotVolumeExtension",
	"AIVolumeExtension",
	"PickupProjectileVolumeExtension",
	"LocalPlayerVolumeExtension"
}

VolumeSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	VolumeSystem.super.init(self, arg_1_1, arg_1_2, tbl)

	self._volume_system = EngineOptimizedExtensions.volume_init_system(self._volume_system, VolumeSystemSettings.updates_per_frame)
	self.nav_tag_volume_handler = nil
	self.nav_tag_volumes_to_create = {}
	self._unit_dead_cbs = {}
end

VolumeSystem.destroy = function (self)
	-- function 2
	VolumeSystem.super.destroy(self)
	EngineOptimizedExtensions.volume_destroy_system(self._volume_system)

	self._volume_system = nil
	self.nav_tag_volume_handler = nil
	self.nav_tag_volumes_to_create = nil
end

local tbl_2 = {}

VolumeSystem.on_add_extension = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local fassert = fassert
	local is_server = self.is_server

	is_server = is_server or arg_3_3 == "LocalPlayerVolumeExtension"

	fassert(is_server, "Only LocalPlayerVolumeExtension is allowed on clients!")
	EngineOptimizedExtensions.volume_on_add_extension(self._volume_system, arg_3_2, arg_3_3)
	ScriptUnit.set_extension(arg_3_2, self.name, tbl_2)

	return tbl_2
end

VolumeSystem.on_remove_extension = function (self, arg_4_1, arg_4_2)
	-- function 4
	self:_cleanup_extension(arg_4_1, arg_4_2)
end

VolumeSystem.on_freeze_extension = function (self, arg_5_1, arg_5_2)
	-- function 5
	self:_cleanup_extension(arg_5_1, arg_5_2)
end

VolumeSystem.freeze = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	self:_cleanup_extension(arg_6_1, arg_6_2)
end

VolumeSystem.unfreeze = function (self, arg_7_1, arg_7_2)
	-- function 7
	EngineOptimizedExtensions.volume_on_add_extension(self._volume_system, arg_7_1, arg_7_2)
	ScriptUnit.set_extension(arg_7_1, self.name, tbl_2)
end

VolumeSystem._cleanup_extension = function (self, arg_8_1, arg_8_2)
	-- function 8
	if ScriptUnit.has_extension(arg_8_1, "volume_system") == nil then
		return
	end

	local var_8_0 = self._unit_dead_cbs[arg_8_1]

	if not var_8_0 then
		var_8_0()

		self._unit_dead_cbs[arg_8_1] = nil
	end

	EngineOptimizedExtensions.volume_on_remove_extension(self._volume_system, arg_8_1, arg_8_2)
	ScriptUnit.remove_extension(arg_8_1, self.name)
end

VolumeSystem.update = function (self, arg_9_1, arg_9_2)
	-- function 9
	EngineOptimizedExtensions.volume_update(self._volume_system, arg_9_2, arg_9_1.dt)
end

VolumeSystem.register_volume = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	local current_level = LevelHelper:current_level(self.world)

	fassert(Level.has_volume(current_level, arg_10_1), "No volume named %q exists in current level", arg_10_1)

	local sub_type = arg_10_3.sub_type

	for i, v in ipairs(tbl) do
		local var_10_2 = VolumeExtensionSettings[arg_10_2][sub_type][v]

		if not var_10_2 then
			local tbl_2 = {
				volume_name = arg_10_1,
				volume_type = arg_10_2,
				level = current_level,
				params = arg_10_3,
				settings = var_10_2,
				inverted = arg_10_3.invert_volume
			}
			local var_10_4
			local var_10_5

			if not GenericVolumeTemplates.functions and not GenericVolumeTemplates.functions[tbl_2.volume_type] and not GenericVolumeTemplates.functions[tbl_2.volume_type][tbl_2.params.sub_type] then
				var_10_4 = GenericVolumeTemplates.functions[tbl_2.volume_type][tbl_2.params.sub_type].on_enter
				var_10_5 = GenericVolumeTemplates.functions[tbl_2.volume_type][tbl_2.params.sub_type].on_exit
			end

			local filter = var_10_2.filter

			EngineOptimizedExtensions.volume_register_volume(self._volume_system, current_level, arg_10_1, v, arg_10_3.invert_volume, tbl_2, var_10_4, var_10_5, filter)
		end
	end

	if not LEVEL_EDITOR_TEST then
		local nav_tag_layer_costs = VolumeSystemSettings.nav_tag_layer_costs

		nav_tag_layer_costs = not nav_tag_layer_costs[arg_10_2] and nav_tag_layer_costs[arg_10_2][sub_type]

		if not nav_tag_layer_costs then
			local str = arg_10_2 .. "_" .. sub_type

			if not self.nav_tag_volume_handler then
				self:create_nav_tag_volume(arg_10_1, str, nav_tag_layer_costs)
			else
				local nav_tag_volumes_to_create = self.nav_tag_volumes_to_create

				nav_tag_volumes_to_create[#nav_tag_volumes_to_create + 1] = {
					volume_name = arg_10_1,
					layer_name = str,
					layer_costs = nav_tag_layer_costs
				}
			end
		end
	end
end

VolumeSystem.unregister_volume = function (self, arg_11_1)
	-- function 11
	local current_level = LevelHelper:current_level(self.world)

	fassert(Level.has_volume(current_level, arg_11_1), "No volume named %q exists in current level", arg_11_1)

	for i, v in ipairs(tbl) do
		EngineOptimizedExtensions.volume_unregister_volume(self._volume_system, current_level, arg_11_1, v)
	end
end

VolumeSystem.ai_ready = function (self)
	-- function 12
	self.nav_tag_volume_handler = Managers.state.conflict.nav_tag_volume_handler

	local nav_tag_volumes_to_create = self.nav_tag_volumes_to_create

	for i = 1, #nav_tag_volumes_to_create do
		local var_12_1 = nav_tag_volumes_to_create[i]

		self:create_nav_tag_volume(var_12_1.volume_name, var_12_1.layer_name, var_12_1.layer_costs)
	end

	self.nav_tag_volumes_to_create = nil
end

VolumeSystem.create_nav_tag_volume_from_data = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	if not LevelHelper:current_level_settings().no_bots_allowed then
		return
	end

	local nav_tag_volume_handler = self.nav_tag_volume_handler
	local create_mapping = nav_tag_volume_handler:create_mapping(arg_13_1, arg_13_2, arg_13_3)

	nav_tag_volume_handler:create_tag_volume_from_mappings(create_mapping)

	return create_mapping
end

VolumeSystem.get_volume_mapping_from_lookup_id = function (self, arg_14_1)
	-- function 14
	local nav_tag_volume_handler = self.nav_tag_volume_handler

	return self.nav_tag_volume_handler:get_mapping_from_lookup_id(arg_14_1)
end

VolumeSystem.destroy_nav_tag_volume = function (self, arg_15_1)
	-- function 15
	self.nav_tag_volume_handler:destroy_nav_tag_volume(arg_15_1)
end

VolumeSystem.create_nav_tag_volume = function (self, arg_16_1, arg_16_2, arg_16_3)
	-- function 16
	if not LevelHelper:current_level_settings().no_bots_allowed then
		return
	end

	local nav_tag_volume_handler = self.nav_tag_volume_handler

	nav_tag_volume_handler:set_mapping_layer_name(arg_16_1, arg_16_2)
	nav_tag_volume_handler:create_tag_volume_from_mappings(arg_16_1)

	local entity = Managers.state.entity
	local BotVolumeExtension = arg_16_3.BotVolumeExtension
	local AIVolumeExtension = arg_16_3.AIVolumeExtension

	if not BotVolumeExtension then
		NAV_TAG_VOLUME_LAYER_COST_BOTS[arg_16_2] = BotVolumeExtension

		Managers.state.bot_nav_transition:set_layer_cost(arg_16_2, BotVolumeExtension)
	end

	if not AIVolumeExtension then
		NAV_TAG_VOLUME_LAYER_COST_AI[arg_16_2] = AIVolumeExtension

		local get_entities = entity:get_entities("AINavigationExtension")

		for k, v in pairs(get_entities) do
			v:set_layer_cost(arg_16_2, AIVolumeExtension)
		end
	end
end

VolumeSystem.volume_has_units_inside = function (self, arg_17_1)
	-- function 17
	return EngineOptimizedExtensions.volume_has_any_units_inside(self._volume_system, arg_17_1)
end

VolumeSystem.any_alive_human_players_inside = function (self, arg_18_1)
	-- function 18
	local PLAYER_UNITS = Managers.state.side:get_side_from_name("heroes").PLAYER_UNITS

	for i, v in ipairs(PLAYER_UNITS) do
		local alive = Unit.alive(v)

		alive = not alive and ScriptUnit.has_extension(v, "status_system")

		if not alive and alive:is_disabled() or not EngineOptimizedExtensions.volume_has_all_units_inside(self._volume_system, arg_18_1, v) then
			return true
		end
	end

	return false
end

VolumeSystem.all_alive_human_players_inside = function (self, arg_19_1)
	-- function 19
	local PLAYER_UNITS = Managers.state.side:get_side_from_name("heroes").PLAYER_UNITS
	local num = 0
	local tbl = {}

	for i, v in ipairs(PLAYER_UNITS) do
		local alive = Unit.alive(v)

		alive = not alive and ScriptUnit.has_extension(v, "status_system")

		if not (not alive and alive:is_disabled()) then
			num = num + 1
			tbl[num] = v
		end
	end

	if num ~= 0 then
		return EngineOptimizedExtensions.volume_has_all_units_inside(self._volume_system, arg_19_1, unpack(tbl))
	end

	return false
end

VolumeSystem.all_alive_or_respawned_human_players_inside = function (self, arg_20_1)
	-- function 20
	local PLAYER_UNITS = Managers.state.side:get_side_from_name("heroes").PLAYER_UNITS
	local num = 0
	local tbl = {}

	for i, v in ipairs(PLAYER_UNITS) do
		local alive = Unit.alive(v)

		alive = not alive and ScriptUnit.has_extension(v, "status_system")

		if not (not alive and not alive:is_disabled() and not alive:is_disabled() and alive:is_ready_for_assisted_respawn()) then
			num = num + 1
			tbl[num] = v
		end
	end

	if num ~= 0 then
		return EngineOptimizedExtensions.volume_has_all_units_inside(self._volume_system, arg_20_1, unpack(tbl))
	end

	return false
end

VolumeSystem.all_human_players_inside_disabled = function (self, arg_21_1)
	-- function 21
	local human_players = Managers.player:human_players()
	local num = 0
	local tbl = {}

	for k, v in pairs(human_players) do
		local player_unit = v.player_unit
		local alive = Unit.alive(player_unit)

		alive = not alive and ScriptUnit.has_extension(player_unit, "status_system")

		if not alive then
			if not alive:is_disabled() then
				return false
			end

			num = num + 1
			tbl[num] = player_unit
		end
	end

	if num ~= 0 then
		return EngineOptimizedExtensions.volume_has_all_units_inside(self._volume_system, arg_21_1, unpack(tbl))
	end

	return false
end

VolumeSystem.player_inside = function (self, arg_22_1, arg_22_2)
	-- function 22
	return EngineOptimizedExtensions.volume_has_all_units_inside(self._volume_system, arg_22_1, arg_22_2)
end

VolumeSystem.register_track_unit_dead = function (arg_23_0, arg_23_1, arg_23_2)
	-- function 23
	arg_23_0._unit_dead_cbs[arg_23_1] = arg_23_2
end

VolumeSystem.unregister_track_unit_dead = function (arg_24_0, arg_24_1, arg_24_2)
	-- function 24
	arg_24_0._unit_dead_cbs[arg_24_1] = nil
end
