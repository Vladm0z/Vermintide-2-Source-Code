-- chunkname: @scripts/entity_system/systems/outlines/outline_system.lua

require("scripts/settings/outline_settings")
require("scripts/unit_extensions/outline/outline_extension")

OutlineSystem = class(OutlineSystem, ExtensionSystemBase)
OutlineSystem.system_extensions = {
	"AIOutlineExtension",
	"PickupOutlineExtension",
	"PlayerHuskOutlineExtension",
	"PlayerOutlineExtension",
	"MinionOutlineExtension",
	"DoorOutlineExtension",
	"ObjectiveOutlineExtension",
	"ObjectiveLightOutlineExtension",
	"ObjectiveLargeOutlineExtension",
	"ElevatorOutlineExtension",
	"ConditionalInteractOutlineExtension",
	"ConditionalPickupOutlineExtension",
	"EnemyOutlineExtension",
	"GenericOutlineExtension",
	"SmallPickupOutlineExtension",
	"SmallDoorOutlineExtension"
}
OutlineSystem.system_extensions[#OutlineSystem.system_extensions + 1] = "DarkPactPlayerOutlineExtension"
OutlineSystem.system_extensions[#OutlineSystem.system_extensions + 1] = "DarkPactPlayerHuskOutlineExtension"

OutlineSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	local system_extensions = OutlineSystem.system_extensions

	OutlineSystem.super.init(self, arg_1_1, arg_1_2, system_extensions)

	self.world = arg_1_1.world
	self.physics_world = World.get_data(self.world, "physics_world")
	self.unit_extension_data = {}
	self.frozen_unit_extension_data = {}
	self.units = {}
	self._initial_outline_data = {}
	self.current_index = 0
	self.darkness_system = Managers.state.entity:system("darkness_system")
	self.cutscene_system = Managers.state.entity:system("cutscene_system")

	local game_mode = Managers.state.game_mode

	self._game_mode = not game_mode and game_mode:game_mode()
	self._pulsing_units = {}
	self._event_manager = Managers.state.event

	self._event_manager:register(self, "on_player_joined_party", "on_player_joined_party")

	self._dirty_units = {}
end

OutlineSystem.add_ext_functions = {
	PlayerOutlineExtension = function (self)
		-- function 2
		local add_outline = self:add_outline({
			method = "never",
			outline_color = OutlineSettings.colors.ally,
			flag = OutlineSettings.flags.non_wall_occluded
		})

		self.apply_method = "unit_and_childs"
		self.pinged_method = "never"

		return add_outline
	end,
	PlayerHuskOutlineExtension = function (self)
		-- function 3
		local add_outline = self:add_outline({
			method = "outside_distance_or_not_visible",
			outline_color = OutlineSettings.colors.ally,
			distance = OutlineSettings.ranges.player_husk,
			flag = OutlineSettings.flags.non_wall_occluded
		})

		self.apply_method = "unit_and_childs"
		self.pinged_method = "always"

		self.update_override_method_player_setting = function (arg_4_0)
			-- function 4
			local var_4_0
			local user_setting = Application.user_setting("player_outlines")
			local flag

			flag = (user_setting ~= "off" or not "never" or user_setting ~= "always_on") and (not "always" or "outside_distance_or_not_visible")

			self:update_outline({
				method = flag
			}, 0)
		end

		self:update_override_method_player_setting()

		return add_outline
	end,
	MinionOutlineExtension = function (self)
		-- function 5
		local add_outline = self:add_outline({
			method = "outside_distance_or_not_visible",
			outline_color = OutlineSettings.colors.necromancer_command,
			distance = OutlineSettings.ranges.player_husk,
			flag = OutlineSettings.flags.non_wall_occluded
		})

		self.apply_method = "unit_and_childs"
		self.pinged_method = "always"

		self.update_override_method_minion_setting = function (arg_6_0)
			-- function 6
			local var_6_0
			local user_setting = Application.user_setting("minion_outlines")
			local flag

			flag = (user_setting ~= "off" or not "never" or user_setting ~= "always_on") and (not "always" or "outside_distance_or_not_visible")

			self:update_outline({
				method = flag
			}, 0)
		end

		self:update_override_method_minion_setting()

		return add_outline
	end,
	PickupOutlineExtension = function (self)
		-- function 7
		local add_outline = self:add_outline({
			method = "within_distance_and_not_in_dark",
			outline_color = OutlineSettings.colors.interactable,
			distance = OutlineSettings.ranges.pickup,
			flag = OutlineSettings.flags.wall_occluded
		})

		self.apply_method = "unit"
		self.pinged_method = "not_in_dark"

		return add_outline
	end,
	AIOutlineExtension = function (self)
		-- function 8
		local add_outline = self:add_outline({
			method = "never",
			outline_color = OutlineSettings.colors.interactable,
			distance = OutlineSettings.ranges.player_husk,
			flag = OutlineSettings.flags.non_wall_occluded
		})

		self.apply_method = "unit"
		self.pinged_method = "not_in_dark"

		return add_outline
	end,
	DoorOutlineExtension = function (self)
		-- function 9
		local add_outline = self:add_outline({
			method = "within_distance_and_not_in_dark",
			outline_color = OutlineSettings.colors.interactable,
			distance = OutlineSettings.ranges.doors,
			flag = OutlineSettings.flags.wall_occluded
		})

		self.apply_method = "unit"
		self.pinged_method = "not_in_dark"

		return add_outline
	end,
	SmallDoorOutlineExtension = function (self)
		-- function 10
		local add_outline = self:add_outline({
			method = "within_distance_and_not_in_dark",
			outline_color = OutlineSettings.colors.interactable,
			distance = OutlineSettings.ranges.small_doors,
			flag = OutlineSettings.flags.wall_occluded
		})

		self.apply_method = "unit"
		self.pinged_method = "not_in_dark"

		return add_outline
	end,
	ObjectiveOutlineExtension = function (self)
		-- function 11
		local add_outline = self:add_outline({
			method = "within_distance",
			outline_color = OutlineSettings.colors.interactable,
			distance = OutlineSettings.ranges.objective,
			flag = OutlineSettings.flags.non_wall_occluded
		})

		self.apply_method = "unit"
		self.pinged_method = "always"

		return add_outline
	end,
	ObjectiveLightOutlineExtension = function (self)
		-- function 12
		local add_outline = self:add_outline({
			method = "within_distance",
			outline_color = OutlineSettings.colors.interactable,
			distance = OutlineSettings.ranges.objective_light,
			flag = OutlineSettings.flags.wall_occluded
		})

		self.apply_method = "unit"
		self.pinged_method = "always"

		return add_outline
	end,
	ObjectiveLargeOutlineExtension = function (self)
		-- function 13
		local add_outline = self:add_outline({
			method = "within_distance",
			outline_color = OutlineSettings.colors.interactable,
			distance = OutlineSettings.ranges.objective_large,
			flag = OutlineSettings.flags.wall_occluded
		})

		self.apply_method = "unit"
		self.pinged_method = "always"

		return add_outline
	end,
	ElevatorOutlineExtension = function (self)
		-- function 14
		local add_outline = self:add_outline({
			method = "within_distance",
			outline_color = OutlineSettings.colors.interactable,
			distance = OutlineSettings.ranges.elevators,
			flag = OutlineSettings.flags.wall_occluded
		})

		self.apply_method = "unit"
		self.pinged_method = "not_in_dark"

		return add_outline
	end,
	ConditionalInteractOutlineExtension = function (self)
		-- function 15
		local add_outline = self:add_outline({
			method = "conditional_within_distance",
			outline_color = OutlineSettings.colors.interactable,
			distance = OutlineSettings.ranges.doors,
			flag = OutlineSettings.flags.wall_occluded
		})

		self.apply_method = "unit"
		self.pinged_method = "always"

		return add_outline
	end,
	ConditionalPickupOutlineExtension = function (self)
		-- function 16
		local add_outline = self:add_outline({
			method = "conditional_within_distance",
			outline_color = OutlineSettings.colors.interactable,
			distance = OutlineSettings.ranges.pickup,
			flag = OutlineSettings.flags.wall_occluded
		})

		self.apply_method = "unit"
		self.pinged_method = "always"

		return add_outline
	end,
	EnemyOutlineExtension = function (self)
		-- function 17
		local add_outline = self:add_outline({
			method = "never",
			outline_color = OutlineSettings.colors.knocked_down,
			flag = OutlineSettings.flags.non_wall_occluded
		})

		self.apply_method = "unit_and_childs"
		self.pinged_method = "not_in_dark"

		return add_outline
	end,
	SmallPickupOutlineExtension = function (self)
		-- function 18
		local add_outline = self:add_outline({
			method = "within_distance_and_not_in_dark",
			outline_color = OutlineSettings.colors.interactable,
			distance = OutlineSettings.ranges.small_pickup,
			flag = OutlineSettings.flags.wall_occluded
		})

		self.apply_method = "unit"
		self.pinged_method = "not_in_dark"

		return add_outline
	end,
	GenericOutlineExtension = function (self)
		-- function 19
		local add_outline = self:add_outline({
			method = "within_distance",
			outline_color = OutlineSettings.colors.interactable,
			distance = OutlineSettings.ranges.interactable,
			flag = OutlineSettings.flags.wall_occluded
		})

		self.apply_method = "unit"
		self.pinged_method = "not_in_dark"

		return add_outline
	end,
	DarkPactPlayerOutlineExtension = function (self)
		-- function 20
		local add_outline = self:add_outline({
			method = "never",
			outline_color = OutlineSettingsVS.colors.ally,
			flag = OutlineSettings.flags.non_wall_occluded
		})

		self.apply_method = "unit_and_childs"
		self.pinged_method = "show_versus_dark_pact_outline"

		return add_outline
	end,
	DarkPactPlayerHuskOutlineExtension = function (self)
		-- function 21
		local var_21_0
		local local_player = Managers.player:local_player()

		if not local_player then
			local network_id = local_player:network_id()
			local local_player_id = local_player:local_player_id()
			local get_party_from_player_id = Managers.party:get_party_from_player_id(network_id, local_player_id)
			local var_21_5 = Managers.state.side.side_by_party[get_party_from_player_id]

			if not (not var_21_5 and var_21_5:name() ~= "dark_pact") then
				var_21_0 = true
			end
		end

		local var_21_6 = self
		local add_outline = self.add_outline
		local tbl = {
			method = "always_same_side"
		}
		local ally

		if not var_21_0 then
			ally = OutlineSettingsVS.colors.ally

			if not ally then
				-- Nothing
			end
		end

		ally = OutlineSettings.colors.knocked_down

		::label_21_0::

		tbl.outline_color = ally
		tbl.distance = OutlineSettings.ranges.player_husk
		tbl.flag = OutlineSettings.flags.non_wall_occluded

		local var_21_10 = add_outline(var_21_6, tbl)

		self.apply_method = "unit_and_childs"
		self.pinged_method = "show_versus_dark_pact_outline"

		return var_21_10
	end
}

OutlineSystem.on_add_extension = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	-- function 22
	local var_22_0 = OutlineExtension:new(arg_22_0, arg_22_2)
	local var_22_1 = OutlineSystem.add_ext_functions[arg_22_3]
	local var_22_2 = var_22_1(var_22_0)

	arg_22_0._initial_outline_data[var_22_0] = {
		setup_func = var_22_1,
		id = var_22_2
	}

	ScriptUnit.set_extension(arg_22_2, "outline_system", var_22_0, {})

	arg_22_0.unit_extension_data[arg_22_2] = var_22_0
	arg_22_0.units[#arg_22_0.units + 1] = arg_22_2

	return var_22_0
end

OutlineSystem.on_remove_extension = function (self, arg_23_1, arg_23_2)
	-- function 23
	self.frozen_unit_extension_data[arg_23_1] = nil

	self:_cleanup_extension(arg_23_1, arg_23_2)
	ScriptUnit.remove_extension(arg_23_1, self.NAME)
end

OutlineSystem.on_player_joined_party = function (self, arg_24_1, arg_24_2, arg_24_3)
	-- function 24
	if Managers.mechanism:current_mechanism_name() == "versus" then
		self:_reinitialize_outlines(arg_24_1, arg_24_3)
	end
end

OutlineSystem._reinitialize_outlines = function (self, arg_25_1, arg_25_2)
	-- function 25
	local is_game_participating_party = Managers.party:is_game_participating_party(arg_25_2)

	if not (arg_25_1 ~= Network.peer_id() or is_game_participating_party) then
		return
	end

	for k, v in pairs(self._initial_outline_data) do
		local setup_func = v.setup_func(k)

		k:swap_delete_outline(setup_func, v.id)

		if not k.update_override_method_player_setting then
			k.update_override_method_player_setting()
		end

		if not k.update_override_method_minion_setting then
			k.update_override_method_minion_setting()
		end
	end
end

OutlineSystem.mark_outline_dirty = function (arg_26_0, arg_26_1)
	-- function 26
	arg_26_0._dirty_units[arg_26_1] = true
end

OutlineSystem.on_freeze_extension = function (self, arg_27_1, arg_27_2)
	-- function 27
	local var_27_0 = self.unit_extension_data[arg_27_1]

	fassert(var_27_0, "Unit was already frozen.")

	self.frozen_unit_extension_data[arg_27_1] = var_27_0

	self:_cleanup_extension(arg_27_1, arg_27_2)
end

OutlineSystem._cleanup_extension = function (self, arg_28_1, arg_28_2)
	-- function 28
	local var_28_0 = self.unit_extension_data[arg_28_1]

	if var_28_0 == nil then
		return
	end

	self._initial_outline_data[var_28_0] = nil
	self.unit_extension_data[arg_28_1] = nil

	table.swap_delete(self.units, table.index_of(self.units, arg_28_1))
end

OutlineSystem.freeze = function (self, arg_29_1, arg_29_2, arg_29_3)
	-- function 29
	local frozen_unit_extension_data = self.frozen_unit_extension_data

	if not frozen_unit_extension_data[arg_29_1] then
		return
	end

	local var_29_1 = self.unit_extension_data[arg_29_1]

	fassert(var_29_1, "Unit to freeze didn't have unfrozen extension")
	self:_cleanup_extension(arg_29_1, arg_29_2)

	self.unit_extension_data[arg_29_1] = nil
	frozen_unit_extension_data[arg_29_1] = var_29_1

	fassert(arg_29_2 == "EnemyOutlineExtension", "Only support for freezing enemy outline extensions")

	if not var_29_1.outlined then
		local outline_color = var_29_1.outline_color
		local color = outline_color.color
		local var_29_4 = Color(color[1], color[2], color[3], color[4])

		self:outline_unit(arg_29_1, var_29_1.flag, var_29_4, false, var_29_1.apply_method, outline_color)

		var_29_1.outlined = false
	end

	var_29_1.method = "never"

	var_29_1:on_freeze()
end

OutlineSystem.unfreeze = function (self, arg_30_1)
	-- function 30
	local var_30_0 = self.frozen_unit_extension_data[arg_30_1]

	fassert(var_30_0, "Unit to unfreeze didn't have frozen extension")

	self.frozen_unit_extension_data[arg_30_1] = nil
	self.unit_extension_data[arg_30_1] = var_30_0
	self.units[#self.units + 1] = arg_30_1

	var_30_0:on_unfreeze()
end

OutlineSystem.local_player_created = function (self, arg_31_1)
	-- function 31
	self._local_player = arg_31_1
	self.camera_unit = arg_31_1.camera_follow_unit
end

OutlineSystem._is_cutscene_active = function (self)
	-- function 32
	local cutscene_system = self.cutscene_system

	if not cutscene_system then
		return false
	end

	local active_camera = cutscene_system.active_camera

	active_camera = not active_camera and not cutscene_system.ingame_hud_enabled

	return active_camera
end

OutlineSystem._is_photomode_active = function (self)
	-- function 33
	local _game_mode = self._game_mode

	return not _game_mode and _game_mode:photomode_enabled()
end

OutlineSystem.set_disabled = function (self, arg_34_1)
	-- function 34
	if not (not arg_34_1 and self._disabled) then
		local units = self.units
		local unit_extension_data = self.unit_extension_data

		for i = 1, #units do
			local var_34_2 = units[i]
			local var_34_3 = unit_extension_data[var_34_2]

			if not var_34_3 and not var_34_3.outlined then
				local outline_color = var_34_3.outline_color
				local color = outline_color.color
				local var_34_6 = Color(color[1], color[2], color[3], color[4])

				self:outline_unit(var_34_2, var_34_3.flag, var_34_6, false, var_34_3.apply_method, outline_color)

				var_34_3.outlined = false
			end
		end
	end

	self._disabled = arg_34_1
end

OutlineSystem.update = function (self, arg_35_1, arg_35_2)
	-- function 35
	if self._disabled or not script_data.disable_outlines then
		return
	end

	if not self.camera_unit then
		return
	end

	local count = #self.units

	if count == 0 then
		return
	end

	local _is_cutscene_active = self:_is_cutscene_active()

	_is_cutscene_active = _is_cutscene_active or self:_is_photomode_active()

	local _dirty_units = self._dirty_units

	for k in pairs(_dirty_units) do
		self:_update_unit_outline(k, _is_cutscene_active)

		_dirty_units[k] = nil
	end

	local dt = arg_35_1.dt
	local min = math.min(count, 20)
	local current_index = self.current_index
	local units = self.units

	for j = 1, min do
		current_index = current_index % count + 1

		local var_35_7 = units[current_index]

		if not self:_update_unit_outline(var_35_7, _is_cutscene_active) then
			break
		end
	end

	self.current_index = current_index

	self:_update_pulsing(dt, arg_35_2)
end

OutlineSystem._update_unit_outline = function (self, arg_36_1, arg_36_2)
	-- function 36
	local var_36_0 = self.unit_extension_data[arg_36_1]

	if not var_36_0 then
		local num = 3
		local num_2 = 0
		local outline_color = var_36_0.outline_color
		local method = var_36_0.method
		local prev_flag = var_36_0.prev_flag

		prev_flag = not prev_flag and var_36_0.prev_flag ~= var_36_0.flag

		if not prev_flag then
			self:outline_unit(arg_36_1, var_36_0.prev_flag, Color(0, 0, 0, 0), false, var_36_0.apply_method, outline_color)

			var_36_0.prev_flag = nil
		end

		local flag = false
		local flag_2 = false

		if not arg_36_2 then
			flag, flag_2 = self[method](self, arg_36_1, var_36_0)
		end

		if var_36_0.outlined ~= flag or not var_36_0.reapply then
			local color = outline_color.color
			local var_36_9 = Color(255, color[2], color[3], color[4])

			self:outline_unit(arg_36_1, var_36_0.flag, var_36_9, flag, var_36_0.apply_method, outline_color)

			var_36_0.outlined = flag
		end

		var_36_0.reapply = false

		if not (not flag_2 and not (num <= num_2 + 1)) then
			return false
		end
	end

	return true
end

local tbl = {
	flash = function (arg_37_0)
		-- function 37
		return math.round(arg_37_0 * 3 % 1)
	end,
	pulse = function (arg_38_0)
		-- function 38
		return math.round(arg_38_0 * 3 % 1.5)
	end
}

OutlineSystem.set_pulsing = function (self, arg_39_1, arg_39_2, arg_39_3)
	-- function 39
	if not arg_39_2 then
		self._pulsing_units[arg_39_1] = tbl[arg_39_3]
	elseif not self._pulsing_units[arg_39_1] then
		self._pulsing_units[arg_39_1] = nil

		local var_39_0 = self.unit_extension_data[arg_39_1]

		if not var_39_0 then
			var_39_0.reapply = true
		end
	end
end

OutlineSystem._update_pulsing = function (self, arg_40_1, arg_40_2)
	-- function 40
	for k, v in pairs(self._pulsing_units) do
		local var_40_0 = self.unit_extension_data[k]

		if not var_40_0 then
			local outline_color = var_40_0.outline_color
			local color = outline_color.color
			local var_40_3 = v(arg_40_2)
			local var_40_4 = Color(color[1] * var_40_3, color[2] * var_40_3, color[3] * var_40_3, color[4] * var_40_3)

			self:outline_unit(k, var_40_0.flag, var_40_4, true, var_40_0.apply_method, outline_color)

			var_40_0.outlined = true
		else
			self._pulsing_units[k] = nil
		end
	end
end

OutlineSystem.outline_unit = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4, arg_41_5, arg_41_6)
	-- function 41
	if not Unit.has_data(arg_41_1, "outlined_meshes") then
		local num = 0

		while not Unit.has_data(arg_41_1, "outlined_meshes", num) do
			local get_data = Unit.get_data(arg_41_1, "outlined_meshes", num)
			local mesh = Unit.mesh(arg_41_1, get_data)

			Mesh.set_shader_pass_flag(mesh, arg_41_2, arg_41_4)

			if not arg_41_4 then
				local num_materials = Mesh.num_materials(mesh)

				for i = 0, num_materials - 1 do
					local material = Mesh.material(mesh, i)

					Material.set_color(material, "outline_color", arg_41_3)

					local set_scalar = Material.set_scalar
					local var_41_6 = material
					local str = "outline_pulse_multiplier"
					local pulse_multiplier

					if not arg_41_6.pulsate then
						pulse_multiplier = arg_41_6.pulse_multiplier

						if not pulse_multiplier then
							-- Nothing
						end
					end

					pulse_multiplier = 0

					::label_41_0::

					set_scalar(var_41_6, str, pulse_multiplier)
				end
			end

			num = num + 1
		end
	elseif arg_41_5 == "unit_and_childs" then
		Unit.set_shader_pass_flag_for_meshes_in_unit_and_childs(arg_41_1, arg_41_2, arg_41_4)
		Unit.set_color_for_materials_in_unit_and_childs(arg_41_1, "outline_color", arg_41_3)

		local set_scalar_for_materials_in_unit_and_childs = Unit.set_scalar_for_materials_in_unit_and_childs
		local var_41_10 = arg_41_1
		local str_2 = "outline_pulse_multiplier"
		local pulse_multiplier_2

		if not arg_41_6.pulsate then
			pulse_multiplier_2 = arg_41_6.pulse_multiplier

			if not pulse_multiplier_2 then
				-- Nothing
			end
		end

		pulse_multiplier_2 = 0

		::label_41_1::

		set_scalar_for_materials_in_unit_and_childs(var_41_10, str_2, pulse_multiplier_2)
	elseif arg_41_5 == "unit" then
		Unit.set_shader_pass_flag_for_meshes(arg_41_1, arg_41_2, arg_41_4)
		Unit.set_color_for_materials(arg_41_1, "outline_color", arg_41_3)

		local set_scalar_for_materials = Unit.set_scalar_for_materials
		local var_41_14 = arg_41_1
		local str_3 = "outline_pulse_multiplier"
		local pulse_multiplier_3

		if not arg_41_6.pulsate then
			pulse_multiplier_3 = arg_41_6.pulse_multiplier

			if not pulse_multiplier_3 then
				-- Nothing
			end
		end

		pulse_multiplier_3 = 0

		::label_41_2::

		set_scalar_for_materials(var_41_14, str_3, pulse_multiplier_3)
	else
		error(sprintf("Non-existant apply method %s", arg_41_5))
	end

	local has_extension = ScriptUnit.has_extension(arg_41_1, "locomotion_system")
	local flag = not has_extension and has_extension.bone_lod_extension_id

	if not flag then
		EngineOptimized.bone_lod_set_ignore_umbra(flag, arg_41_4)
	end
end

OutlineSystem.raycast_result = function (self, arg_42_1)
	-- function 42
	local physics_world = self.physics_world
	local local_position = Unit.local_position(self.camera_unit, 0)
	local distance = Vector3.distance(local_position, arg_42_1)
	local normalize = Vector3.normalize(arg_42_1 - local_position)
	local immediate_raycast, var_42_5 = PhysicsWorld.immediate_raycast(physics_world, local_position, normalize, distance, "all", "collision_filter", "filter_ai_line_of_sight_check")

	return immediate_raycast, var_42_5
end

OutlineSystem.distance_sq_to_unit = function (self, arg_43_1)
	-- function 43
	local local_position = Unit.local_position(self.camera_unit, 0)
	local box, var_43_2 = Unit.box(arg_43_1)
	local translation = Matrix4x4.translation(box)

	return (Vector3.distance_squared(local_position, translation))
end

local flag = true

OutlineSystem.never = function (arg_44_0, arg_44_1, arg_44_2)
	-- function 44
	return false
end

OutlineSystem.ai_alive = function (arg_45_0, arg_45_1, arg_45_2)
	-- function 45
	return not not HEALTH_ALIVE[arg_45_1]
end

OutlineSystem.always = function (arg_46_0, arg_46_1, arg_46_2)
	-- function 46
	return true
end

OutlineSystem.always_same_side = function (self, arg_47_1, arg_47_2)
	-- function 47
	local same_side = arg_47_2.same_side

	if not same_side then
		local var_47_1 = Managers.state.side.side_by_unit[arg_47_1]
		local var_47_2 = Managers.state.side.side_by_party[self._local_player:get_party()]

		same_side = not Managers.state.side:is_enemy_by_side(var_47_1, var_47_2)
		arg_47_2.same_side = same_side
	end

	return same_side
end

OutlineSystem.same_side_in_ghost_mode = function (self, arg_48_1, arg_48_2)
	-- function 48
	local status_extension = arg_48_2.status_extension

	if status_extension == nil then
		status_extension = ScriptUnit.has_extension(arg_48_1, "status_system")
		arg_48_2.status_extension = status_extension or false
	end

	if not status_extension then
		-- Nothing
	end

	::label_48_0::

	local get_in_ghost_mode = status_extension:get_in_ghost_mode()

	get_in_ghost_mode = not get_in_ghost_mode and self:always_same_side(arg_48_1, arg_48_2)

	::label_48_1::

	return get_in_ghost_mode
end

OutlineSystem.visible = function (self, arg_49_1, arg_49_2)
	-- function 49
	local box, var_49_1 = Unit.box(arg_49_1)
	local translation = Matrix4x4.translation(box)

	return not not self.darkness_system:is_in_darkness(translation) or not self:raycast_result(translation), flag
end

OutlineSystem.not_in_dark = function (self, arg_50_1, arg_50_2)
	-- function 50
	local box, var_50_1 = Unit.box(arg_50_1)
	local translation = Matrix4x4.translation(box)

	return not self.darkness_system:is_in_darkness(translation)
end

OutlineSystem.not_visible = function (self, arg_51_1, arg_51_2)
	-- function 51
	return not self:visible(arg_51_1, arg_51_2), flag
end

OutlineSystem.within_distance_and_not_in_dark = function (self, arg_52_1, arg_52_2)
	-- function 52
	if not self:within_distance(arg_52_1, arg_52_2) then
		return false
	end

	local box, var_52_1 = Unit.box(arg_52_1)
	local translation = Matrix4x4.translation(box)

	return not self.darkness_system:is_in_darkness(translation)
end

OutlineSystem.within_distance = function (self, arg_53_1, arg_53_2)
	-- function 53
	return self:distance_sq_to_unit(arg_53_1) <= arg_53_2.distance * arg_53_2.distance
end

OutlineSystem.outside_distance = function (self, arg_54_1, arg_54_2)
	-- function 54
	return self:distance_sq_to_unit(arg_54_1) > arg_54_2.distance * arg_54_2.distance
end

OutlineSystem.outside_distance_or_not_visible = function (self, arg_55_1, arg_55_2)
	-- function 55
	if not self:outside_distance(arg_55_1, arg_55_2) then
		return true
	end

	if not self:not_visible(arg_55_1, arg_55_2) then
		return true, flag
	end

	return false, flag
end

OutlineSystem.within_distance_and_visible = function (self, arg_56_1, arg_56_2)
	-- function 56
	if not self:within_distance(arg_56_1, arg_56_2) and not self:visible(arg_56_1, arg_56_2) then
		return true, flag
	end

	return false
end

OutlineSystem.conditional_within_distance = function (self, arg_57_1, arg_57_2)
	-- function 57
	if not self:within_distance(arg_57_1, arg_57_2) then
		local get_data = Unit.get_data(arg_57_1, "interaction_data", "interaction_type")
		local var_57_1 = InteractionDefinitions[get_data]
		local player_unit = Managers.player:local_player().player_unit
		local flag = false

		if not player_unit then
			flag = var_57_1.client.can_interact(player_unit, arg_57_1)
		end

		return flag
	end

	return false
end

OutlineSystem.in_ghost_mode = function (arg_58_0, arg_58_1, arg_58_2)
	-- function 58
	local has_extension = ScriptUnit.has_extension(arg_58_1, "ghost_mode_system")

	return not has_extension and has_extension:is_in_ghost_mode()
end

OutlineSystem.has_gutter_runner_invisible_buff = function (arg_59_0, arg_59_1, arg_59_2)
	-- function 59
	local extension = ScriptUnit.extension(arg_59_1, "buff_system")

	return not extension and extension:has_buff_type("vs_gutter_runner_smoke_bomb_invisible")
end

OutlineSystem.show_versus_dark_pact_outline = function (self, arg_60_1, arg_60_2)
	-- function 60
	if not self:within_distance_and_not_in_dark(arg_60_1, arg_60_2) then
		return false
	end

	if not self:in_ghost_mode(arg_60_1, arg_60_2) then
		return false
	end

	return not self:has_gutter_runner_invisible_buff(arg_60_1, arg_60_2)
end

OutlineSystem.destroy = function (self)
	-- function 61
	self._event_manager:unregister("on_player_joined_party", self)
end
