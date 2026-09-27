-- chunkname: @scripts/unit_extensions/weapons/actions/action_sweep.lua

ActionSweep = class(ActionSweep, ActionBase)

local tbl = {
	"damage_profile",
	"impact_sound_event",
	"no_damage_impact_sound_event",
	"slide_armour_hit",
	"hit_mass_count",
	"hit_effect",
	"use_precision_sweep",
	"invert_attack_direction",
	"additional_critical_strike_chance",
	"hit_stop_anim"
}
local count = #tbl
local alive = Unit.alive
local get_data = Unit.get_data
local world_position = Unit.world_position
local world_rotation = Unit.world_rotation
local local_rotation = Unit.local_rotation
local flow_event = Unit.flow_event
local set_flow_variable = Unit.set_flow_variable
local node = Unit.node
local has_node = Unit.has_node
local actor = Unit.actor
local animation_event = Unit.animation_event
local has_animation_event = Unit.has_animation_event
local has_animation_state_machine = Unit.has_animation_state_machine
local node_2 = Actor.node
local degrees_to_radians = math.degrees_to_radians(120)
local degrees_to_radians_2 = math.degrees_to_radians(115.55)
local num = 1
local num_2 = 2
local num_3 = 5

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local count = #arg_1_1

	for i = 1, count do
		local var_1_1 = arg_1_1[i]
		local var_1_2 = arg_1_1[math.min(i + 1, count)]

		if not (var_1_1 == var_1_2 or i ~= 1 or not (arg_1_0 <= var_1_1[num])) then
			local var_1_3 = Vector3(var_1_1[num_2], var_1_1[num_2 + 1], var_1_1[num_2 + 2])
			local from_elements = Quaternion.from_elements(var_1_1[num_3], var_1_1[num_3 + 1], var_1_1[num_3 + 2], var_1_1[num_3 + 3])

			return Matrix4x4.from_quaternion_position(from_elements, var_1_3)
		elseif not (not (arg_1_0 >= var_1_1[num]) or not (arg_1_0 <= var_1_2[num])) then
			local max = math.max(var_1_2[num] - var_1_1[num], 0.0001)
			local num_4 = (arg_1_0 - var_1_1[num]) / max
			local var_1_7 = Vector3(var_1_1[num_2], var_1_1[num_2 + 1], var_1_1[num_2 + 2])
			local from_elements_2 = Quaternion.from_elements(var_1_1[num_3], var_1_1[num_3 + 1], var_1_1[num_3 + 2], var_1_1[num_3 + 3])
			local var_1_9 = Vector3(var_1_2[num_2], var_1_2[num_2 + 1], var_1_2[num_2 + 2])
			local from_elements_3 = Quaternion.from_elements(var_1_2[num_3], var_1_2[num_3 + 1], var_1_2[num_3 + 2], var_1_2[num_3 + 3])
			local lerp = Vector3.lerp(var_1_7, var_1_9, num_4)
			local lerp_2 = Quaternion.lerp(from_elements_2, from_elements_3, num_4)

			return Matrix4x4.from_quaternion_position(lerp_2, lerp)
		end
	end

	return nil, nil
end

local function fn_2(arg_2_0)
	-- function 2
	if not arg_2_0 then
		return "baked_sweep_" .. arg_2_0
	else
		return "baked_sweep"
	end
end

ActionSweep.init = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7, arg_3_8)
	-- function 3
	ActionSweep.super.init(self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7, arg_3_8)

	self.stored_half_extents = Vector3Box()
	self._stored_position = Vector3Box()
	self._stored_rotation = QuaternionBox()

	local box, var_3_1 = Unit.box(arg_3_5)

	self.stored_half_extents:store(var_3_1)

	self._hit_units = {}
	self._overridable_settings = {}
	self._could_damage_last_update = false
	self._has_played_rumble_effect = false
	self._status_extension = ScriptUnit.extension(arg_3_4, "status_system")
	self._weapon_extension = ScriptUnit.extension(arg_3_7, "weapon_system")
	self._stored_attack_data = {}
	self._dt = 0
end

ActionSweep.check_precision_target = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local _precision_target_unit = self._precision_target_unit

	if not HEALTH_ALIVE[_precision_target_unit] then
		return nil
	end

	local extension = ScriptUnit.extension(arg_4_1, "first_person_system")

	extension:disable_rig_movement()

	local current_position = extension:current_position()
	local current_rotation = extension:current_rotation()
	local forward = Quaternion.forward(current_rotation)
	local str = "j_spine"
	local var_4_6

	if not has_node(_precision_target_unit, "j_spine") then
		var_4_6 = world_position(_precision_target_unit, node(_precision_target_unit, str))

		if not var_4_6 then
			-- Nothing
		end
	end

	var_4_6 = world_position(_precision_target_unit, 0)

	::label_4_0::

	local flag = false
	local num = var_4_6 - current_position
	local length = Vector3.length(num)
	local normalize = Vector3.normalize(num)

	if not (Vector3.dot(normalize, forward) < 0.9 or not (arg_4_3 < length)) then
		flag = false
	elseif not HEALTH_ALIVE[_precision_target_unit] then
		flag = true
	end

	return not flag and _precision_target_unit and nil
end

ActionSweep.client_owner_start_action = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	ActionSweep.super.client_owner_start_action(self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)

	self._has_played_rumble_effect = false
	self._current_action = arg_5_1
	self._action_time_started = arg_5_2
	self._has_hit_environment = false
	self._has_hit_precision_target = true
	self._precision_target_unit = nil
	self._number_of_hit_enemies = 0
	self._this_attack_killed_enemy = false
	self._amount_of_mass_hit = 0
	self._number_of_potential_hit_results = 0
	self._hit_mass_of_potential_hit_results = 0
	self._network_manager = Managers.state.network
	self._last_potential_hit_result_has_result = false
	self._last_potential_hit_result = {}
	self.has_been_within_damage_window = false

	local owner_unit = self.owner_unit
	local extension = ScriptUnit.extension(owner_unit, "buff_system")
	local has_extension = ScriptUnit.has_extension(owner_unit, "hud_system")

	self._owner_buff_extension = extension
	self._owner_hud_extension = has_extension

	local get_action_time_scale = ActionUtils.get_action_time_scale(owner_unit, arg_5_1)

	self._anim_time_scale = get_action_time_scale

	local hit_time = arg_5_1.hit_time

	hit_time = hit_time or 0
	self._time_to_hit = arg_5_2 + hit_time / get_action_time_scale

	local var_5_5
	local weapon_mode_key = arg_5_1.weapon_mode_key
	local weapon_mode_overrides = arg_5_1.weapon_mode_overrides

	if not weapon_mode_key then
		var_5_5 = weapon_mode_overrides[self._weapon_extension:get_custom_data(weapon_mode_key)]
	end

	self:_populate_sweep_action_data(arg_5_1, var_5_5)

	local flag = not arg_5_5 and arg_5_5.action_hand
	local _get_damage_profile_name = self:_get_damage_profile_name(flag, arg_5_1)

	self._action_hand = flag
	self._baked_sweep_data = arg_5_1[fn_2(self._action_hand)]

	local num

	if not self._baked_sweep_data then
		num = 1 / #self._baked_sweep_data

		if not num then
			-- Nothing
		end
	end

	num = 1

	::label_5_0::

	self._baked_data_dt_recip = num
	self._damage_profile_id = NetworkLookup.damage_profiles[_get_damage_profile_name]

	local var_5_11 = DamageProfileTemplates[_get_damage_profile_name]

	self._damage_profile = var_5_11
	self._has_starting_melee_boost = nil
	self._starting_melee_boost_curve_multiplier = nil

	local _get_power_boost, var_5_13 = self:_get_power_boost()
	local is_critical_strike = ActionUtils.is_critical_strike(owner_unit, arg_5_1, arg_5_2, var_5_5)

	is_critical_strike = is_critical_strike or _get_power_boost

	local get_difficulty = Managers.state.difficulty:get_difficulty()
	local scale_power_levels = ActionUtils.scale_power_levels(arg_5_4, "cleave", owner_unit, get_difficulty)
	local apply_buffs_to_value = extension:apply_buffs_to_value(scale_power_levels, "power_level_melee")
	local apply_buffs_to_value_2 = extension:apply_buffs_to_value(apply_buffs_to_value, "power_level_melee_cleave")

	self._power_level = arg_5_4

	local get_max_targets, var_5_20 = ActionUtils.get_max_targets(var_5_11, apply_buffs_to_value_2)
	local apply_buffs_to_value_3 = extension:apply_buffs_to_value(get_max_targets or 1, "increased_max_targets")
	local apply_buffs_to_value_4 = extension:apply_buffs_to_value(var_5_20 or 1, "increased_max_targets")

	if not extension:has_buff_perk("potion_armor_penetration") then
		apply_buffs_to_value_4 = apply_buffs_to_value_4 * 2
	end

	self._max_targets_attack = apply_buffs_to_value_3
	self._max_targets_impact = apply_buffs_to_value_4
	self._max_targets = not (apply_buffs_to_value_4 < apply_buffs_to_value_3) or not apply_buffs_to_value_3 or apply_buffs_to_value_4

	local sweep_z_offset = arg_5_1.sweep_z_offset

	sweep_z_offset = sweep_z_offset or 0.1
	self._down_offset = sweep_z_offset
	self._auto_aim_reset = false

	if not (Managers.player:owner(self.owner_unit).bot_player or var_5_11.charge_value ~= "heavy_attack") then
		Managers.state.controller_features:add_effect("rumble", {
			rumble_effect = "light_swing"
		})
	end

	local first_person_unit = self.first_person_unit

	if not global_is_inside_inn then
		self._down_offset = 0
	end

	self._attack_aborted = false
	self._send_delayed_hit_rpc = false

	table.clear(self._hit_units)
	extension:trigger_procs("on_sweep")

	self._unlimited_cleave = not not arg_5_1.unlimited_cleave

	if self._unlimited_cleave or not is_critical_strike then
		self._unlimited_cleave = extension:has_buff_perk("crit_unlimited_cleave")
	end

	local extension_2 = ScriptUnit.extension(owner_unit, "first_person_system")

	self:_handle_critical_strike(is_critical_strike, extension, has_extension, extension_2, "on_critical_sweep", "Play_player_combat_crit_swing_2D")

	self._is_critical_strike = is_critical_strike
	self._started_damage_window = false

	flow_event(first_person_unit, "sfx_swing_started")

	if not self._overridable_settings.use_precision_sweep then
		extension_2:disable_rig_movement()

		local get_data_2 = World.get_data(self.world, "physics_world")
		local current_position = extension_2:current_position()
		local current_rotation = extension_2:current_rotation()
		local forward = Quaternion.forward(current_rotation)
		local str = "filter_melee_sweep"
		local immediate_raycast = PhysicsWorld.immediate_raycast(get_data_2, current_position, forward, arg_5_1.dedicated_target_range, "all", "collision_filter", str)

		if not immediate_raycast then
			local enemy_units_lookup = Managers.state.side.side_by_unit[owner_unit].enemy_units_lookup
			local count = #immediate_raycast

			for i = 1, count do
				local var_5_34 = immediate_raycast[i][4]
				local unit = Actor.unit(var_5_34)
				local var_5_36 = get_data(unit, "breed")
				local flag_2 = not enemy_units_lookup[unit]

				if not (not var_5_36 and flag_2) then
					local var_5_38 = node_2(var_5_34)

					if var_5_36.hit_zones_lookup[var_5_38].name == "afro" or not HEALTH_ALIVE[unit] then
						self._precision_target_unit = unit
						self._has_hit_precision_target = false

						break
					end
				end
			end
		end

		if self._precision_target_unit or not ScriptUnit.has_extension(owner_unit, "smart_targeting_system") then
			local unit_2 = ScriptUnit.extension(owner_unit, "smart_targeting_system"):get_targeting_data().unit

			if not HEALTH_ALIVE[unit_2] then
				self._precision_target_unit = unit_2
				self._has_hit_precision_target = false
			end
		end
	end

	local weapon_unit = self.weapon_unit
	local _weapon_sweep_rotation = self:_weapon_sweep_rotation(arg_5_1, weapon_unit)
	local up = Quaternion.up(_weapon_sweep_rotation)
	local weapon_up_offset_mod = arg_5_1.weapon_up_offset_mod

	weapon_up_offset_mod = weapon_up_offset_mod or 0

	local num_2 = up * weapon_up_offset_mod
	local var_5_45 = POSITION_LOOKUP[weapon_unit]
	local num_3 = Vector3(var_5_45.x, var_5_45.y, var_5_45.z - self._down_offset) + num_2

	self._stored_position:store(num_3)
	self._stored_rotation:store(_weapon_sweep_rotation)

	self._could_damage_last_update = false

	if arg_5_1.lookup_data.sub_action_name == "assassinate" then
		local get_non_stacking_buff = extension:get_non_stacking_buff("assassinate")

		extension:remove_buff(get_non_stacking_buff.id)
	end
end

local tbl_2 = {}

if not PhysicsWorld.stop_reusing_sweep_tables then
	PhysicsWorld.stop_reusing_sweep_tables()
end

ActionSweep.client_owner_post_update = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	local owner_unit = self.owner_unit
	local _current_action = self._current_action

	self.current_time_in_action = arg_6_5
	self._dt = arg_6_1

	local flag = false

	if not ((flag or not self._attack_aborted or not _current_action.reset_aim_on_attack) and self._auto_aim_reset) then
		ScriptUnit.extension(owner_unit, "first_person_system"):reset_aim_assist_multiplier()

		self._auto_aim_reset = true
	end

	local num = arg_6_5 - 2 * arg_6_1
	local _update_sweep = self:_update_sweep(arg_6_1, arg_6_2, _current_action, num)
	local _started_damage_window = self._started_damage_window

	_started_damage_window = _started_damage_window or _update_sweep
	self._started_damage_window = _started_damage_window

	if not self._is_critical_strike then
		local _owner_hud_extension = self._owner_hud_extension

		if not _owner_hud_extension and not _owner_hud_extension.show_critical_indication and _update_sweep or not self._started_damage_window then
			_owner_hud_extension.show_critical_indication = false
		end
	end
end

ActionSweep._update_sweep = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	local var_7_0

	if not self._baked_sweep_data then
		var_7_0 = self:_update_sweep_baked(arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	else
		var_7_0 = self:_update_sweep_runtime(arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	end

	if not (not self._send_delayed_hit_rpc and not (arg_7_2 >= self._time_to_hit)) then
		local _stored_attack_data = self._stored_attack_data

		self:_send_attack_hit(arg_7_2, _stored_attack_data.damage_source_id, _stored_attack_data.attacker_unit_id, _stored_attack_data.hit_unit_id, _stored_attack_data.hit_zone_id, _stored_attack_data.hit_position:unbox(), _stored_attack_data.attack_direction:unbox(), _stored_attack_data.damage_profile_id, unpack(_stored_attack_data.optional_parameters))

		self._send_delayed_hit_rpc = false
	end

	return var_7_0
end

ActionSweep._update_sweep_baked = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	local var_8_0
	local num = arg_8_3.damage_window_start / self._anim_time_scale

	if arg_8_4 + arg_8_1 >= num - 0.03333333333333333 then
		local owner_unit = self.owner_unit
		local weapon_unit = self.weapon_unit
		local physics_world = self.physics_world
		local _baked_sweep_data = self._baked_sweep_data
		local flag = false
		local num_2 = 0
		local num_3 = 0.016666666666666666
		local get_first_person_unit = ScriptUnit.extension(owner_unit, "first_person_system"):get_first_person_unit()
		local world_pose = Unit.world_pose(get_first_person_unit, 0)

		while not (flag or self._attack_aborted or not (num_2 < arg_8_1)) do
			local min = math.min(num_3, arg_8_1 - num_2)

			num_2 = math.min(num_2 + num_3, arg_8_1)

			local num_4 = (arg_8_4 + num_2) * self._anim_time_scale
			local var_8_13 = fn(num_4, _baked_sweep_data)
			local multiply = Matrix4x4.multiply(var_8_13, world_pose)
			local translation = Matrix4x4.translation(multiply)
			local rotation = Matrix4x4.rotation(multiply)

			var_8_0 = self:_is_within_damage_window(arg_8_4 + num_2, arg_8_3, owner_unit)
			flag = self:_do_overlap(min, arg_8_2, weapon_unit, owner_unit, arg_8_3, physics_world, var_8_0, translation, rotation)
		end
	end

	return var_8_0
end

ActionSweep._update_sweep_runtime = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	local owner_unit = self.owner_unit
	local weapon_unit = self.weapon_unit
	local physics_world = self.physics_world
	local forced_interpolation = arg_9_3.forced_interpolation

	forced_interpolation = forced_interpolation or 0.016666666666666666

	local num = 0
	local unbox = self._stored_position:unbox()
	local unbox_2 = self._stored_rotation:unbox()
	local var_9_7 = POSITION_LOOKUP[weapon_unit]
	local _weapon_sweep_rotation = self:_weapon_sweep_rotation(arg_9_3, weapon_unit)
	local flag = false
	local var_9_10

	while not (flag or self._attack_aborted or not (num < arg_9_1)) do
		local min = math.min(forced_interpolation, arg_9_1 - num)

		num = math.min(num + forced_interpolation, arg_9_1)

		local num_2 = num / arg_9_1
		local lerp = Vector3.lerp(unbox, var_9_7, num_2)
		local lerp_2 = Quaternion.lerp(unbox_2, _weapon_sweep_rotation, num_2)

		var_9_10 = self:_is_within_damage_window(arg_9_4 + num, arg_9_3, owner_unit)
		flag = self:_do_overlap(min, arg_9_2, weapon_unit, owner_unit, arg_9_3, physics_world, var_9_10, lerp, lerp_2)
	end

	return var_9_10
end

ActionSweep._get_power_boost = function (self)
	-- function 10
	local _has_starting_melee_boost = self._has_starting_melee_boost
	local _starting_melee_boost_curve_multiplier = self._starting_melee_boost_curve_multiplier

	if not _has_starting_melee_boost then
		local owner_unit = self.owner_unit
		local _damage_profile = self._damage_profile
		local flag = not _damage_profile and _damage_profile.melee_boost_override

		_has_starting_melee_boost, _starting_melee_boost_curve_multiplier = ActionUtils.get_melee_boost(owner_unit, flag)
		self._has_starting_melee_boost, self._starting_melee_boost_curve_multiplier = _has_starting_melee_boost, _starting_melee_boost_curve_multiplier
	end

	return _has_starting_melee_boost, _starting_melee_boost_curve_multiplier
end

ActionSweep._is_within_damage_window = function (self, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	local damage_window_start = arg_11_2.damage_window_start
	local damage_window_end = arg_11_2.damage_window_end

	if not (damage_window_start or damage_window_end) then
		return false
	end

	local _anim_time_scale = self._anim_time_scale
	local num = damage_window_start / _anim_time_scale

	damage_window_end = damage_window_end or arg_11_2.total_time or math.huge

	local num_2 = damage_window_end / _anim_time_scale
	local flag = num < arg_11_1
	local flag_2 = arg_11_1 < num_2

	return not flag and flag_2
end

ActionSweep._get_target_hit_mass = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6)
	-- function 12
	local var_12_0

	if not arg_12_2 then
		if not arg_12_4.hit_mass_counts_block then
			var_12_0 = arg_12_4.hit_mass_counts_block[arg_12_1]

			if not var_12_0 then
				-- Nothing
			end

			var_12_0 = arg_12_4.hit_mass_counts_block[2]

			if not var_12_0 then
				-- Nothing
			end
		end

		var_12_0 = arg_12_4.hit_mass_count_block

		if not var_12_0 then
			-- Nothing
		end
	end

	if not arg_12_4.hit_mass_counts then
		var_12_0 = arg_12_4.hit_mass_counts[arg_12_1]

		if not var_12_0 then
			-- Nothing
		end

		var_12_0 = arg_12_4.hit_mass_counts[2]

		if not var_12_0 then
			-- Nothing
		end
	end

	var_12_0 = arg_12_4.hit_mass_count
	var_12_0 = var_12_0 or 1

	::label_12_0::

	local hit_mass_count = self._overridable_settings.hit_mass_count

	if not self._unlimited_cleave then
		var_12_0 = 0

		return var_12_0
	elseif not hit_mass_count and not hit_mass_count[arg_12_4.name] then
		var_12_0 = var_12_0 * (hit_mass_count[arg_12_4.name] or 1)
	end

	local game = self._network_manager:game()

	if not arg_12_4.is_player then
		local game_object_field = GameSession.game_object_field(game, arg_12_5, "bt_action_name")

		if NetworkLookup.bt_action_names[game_object_field] == "stagger" then
			var_12_0 = var_12_0 * 0.75
		end
	end

	local has_extension = ScriptUnit.has_extension(arg_12_6, "buff_system")

	if not has_extension then
		var_12_0 = has_extension:apply_buffs_to_value(var_12_0, "hit_mass_amount")
	end

	return (self._owner_buff_extension:apply_buffs_to_value(var_12_0, "hit_mass_reduction"))
end

ActionSweep._calculate_hit_mass = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6, arg_13_7)
	-- function 13
	local flag = false
	local flag_2 = false

	if not HEALTH_ALIVE[arg_13_7] then
		flag = self._amount_of_mass_hit <= self._max_targets_attack
		flag_2 = self._amount_of_mass_hit <= self._max_targets_impact

		local _get_target_hit_mass = self:_get_target_hit_mass(arg_13_1, arg_13_3, arg_13_4, arg_13_5, arg_13_6, arg_13_7)

		self._amount_of_mass_hit = self._amount_of_mass_hit + _get_target_hit_mass
		self._number_of_hit_enemies = self._number_of_hit_enemies + 1
		arg_13_2 = self._number_of_hit_enemies
	else
		arg_13_3 = false
	end

	return math.ceil(arg_13_2), arg_13_3, flag, flag_2
end

ActionSweep._calculate_hit_mass_level_object = function (self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	if not HEALTH_ALIVE[arg_14_1] then
		local var_14_0 = get_data(arg_14_1, "hit_mass")

		if not self._unlimited_cleave then
			var_14_0 = 0
		end

		self._amount_of_mass_hit = self._amount_of_mass_hit + var_14_0
		self._number_of_hit_enemies = self._number_of_hit_enemies + 1
	end
end

ActionSweep._calculate_attack_direction = function (self, arg_15_1, arg_15_2)
	-- function 15
	local attack_direction = arg_15_1.attack_direction

	attack_direction = attack_direction or "forward"

	local var_15_1 = Quaternion[attack_direction](arg_15_2)
	local num

	if not self._overridable_settings.invert_attack_direction then
		num = -var_15_1

		if not num then
			-- Nothing
		end
	end

	num = var_15_1

	::label_15_0::

	return num
end

ActionSweep._check_backstab = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
	-- function 16
	local num = 1

	if not arg_16_1 and not HEALTH_ALIVE[arg_16_2] then
		local var_16_1 = POSITION_LOOKUP[arg_16_3]
		local var_16_2 = world_position(arg_16_2, 0)
		local normalize = Vector3.normalize(var_16_2 - var_16_1)
		local forward = Quaternion.forward(local_rotation(arg_16_2, 0))
		local dot = Vector3.dot(forward, normalize)

		if not (dot >= 0.55) or dot <= 1 or not arg_16_4 or not arg_16_4:has_buff_perk("guaranteed_backstab") then
			num = arg_16_4:apply_buffs_to_value(num, "backstab_multiplier")

			if not script_data.debug_legendary_traits then
				num = 1.5
			end

			if num > 1 then
				arg_16_5:play_hud_sound_event("hud_player_buff_backstab")

				local PLAYER_AND_BOT_UNITS = Managers.state.side.side_by_unit[arg_16_3].PLAYER_AND_BOT_UNITS

				for i = 1, #PLAYER_AND_BOT_UNITS do
					local var_16_7 = PLAYER_AND_BOT_UNITS[i]
					local has_extension = ScriptUnit.has_extension(var_16_7, "buff_system")

					if not has_extension then
						has_extension:trigger_procs("on_backstab", arg_16_2)
					end
				end
			end
		end
	end

	return num
end

ActionSweep._send_attack_hit = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8, ...)
	-- function 17
	if arg_17_1 < self._time_to_hit then
		local var_17_0 = Vector3Box(arg_17_6)
		local var_17_1 = Vector3Box(arg_17_7)

		table.clear(self._stored_attack_data)

		self._stored_attack_data.damage_source_id = arg_17_2
		self._stored_attack_data.attacker_unit_id = arg_17_3
		self._stored_attack_data.hit_unit_id = arg_17_4
		self._stored_attack_data.hit_zone_id = arg_17_5
		self._stored_attack_data.hit_position = var_17_0
		self._stored_attack_data.attack_direction = var_17_1
		self._stored_attack_data.damage_profile_id = arg_17_8
		self._stored_attack_data.optional_parameters = {
			...
		}
		self._send_delayed_hit_rpc = true
	else
		self.weapon_system:send_rpc_attack_hit(arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8, ...)

		local impact_explosion_template = self._current_action.impact_explosion_template

		if not impact_explosion_template then
			local game_object_or_level_unit = self._network_manager:game_object_or_level_unit(arg_17_4)
			local has_node = Unit.has_node(game_object_or_level_unit, "c_spine")

			has_node = not has_node and Unit.node(game_object_or_level_unit, "c_spine")

			local world_position

			if not has_node then
				world_position = Unit.world_position(game_object_or_level_unit, has_node)

				if not world_position then
					-- Nothing
				end
			end

			world_position = arg_17_6

			::label_17_0::

			local world = self.world
			local owner_unit = self.owner_unit
			local unbox = self._stored_rotation:unbox()
			local num = 1
			local item_name = self.item_name
			local _power_level = self._power_level
			local is_server = self.is_server
			local flag = false
			local flag_2 = false
			local weapon_unit = self.weapon_unit
			local network = Managers.state.network
			local network_transmit = network.network_transmit
			local get_template = ExplosionUtils.get_template(impact_explosion_template)
			local unit_game_object_id = network:unit_game_object_id(owner_unit)
			local var_17_20 = NetworkLookup.explosion_templates[impact_explosion_template]

			if not is_server then
				network_transmit:send_rpc_clients("rpc_create_explosion", unit_game_object_id, false, world_position, unbox, var_17_20, num, arg_17_2, _power_level, flag_2, unit_game_object_id)
			else
				network_transmit:send_rpc_server("rpc_create_explosion", unit_game_object_id, false, world_position, unbox, var_17_20, num, arg_17_2, _power_level, flag_2, unit_game_object_id)
			end

			DamageUtils.create_explosion(world, owner_unit, world_position, unbox, get_template, num, item_name, is_server, flag, weapon_unit, _power_level, flag_2)
		end
	end
end

function _revalidate_actor_and_get_unit(arg_18_0)
	-- function 18
	local unit

	if Script.type_name(arg_18_0) == "Actor" then
		unit = Actor.unit(arg_18_0)

		if not unit then
			-- Nothing
		end
	end

	unit = nil

	::label_18_0::

	return unit
end

ActionSweep._do_overlap = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7, arg_19_8, arg_19_9)
	-- function 19
	if not self._attack_aborted then
		return
	end

	local up = Quaternion.up(arg_19_9)
	local flag = false
	local _network_manager = self._network_manager
	local weapon_system = self.weapon_system
	local up_2 = Quaternion.up(arg_19_9)
	local weapon_up_offset_mod = arg_19_5.weapon_up_offset_mod

	weapon_up_offset_mod = weapon_up_offset_mod or 0

	local num = up_2 * weapon_up_offset_mod

	if not (arg_19_7 or self._could_damage_last_update) then
		local var_19_7 = arg_19_8
		local num_2 = Vector3(var_19_7.x, var_19_7.y, var_19_7.z - self._down_offset) + num

		self._stored_position:store(num_2)
		self._stored_rotation:store(arg_19_9)

		return
	end

	local flag_2 = not not arg_19_7 or self._could_damage_last_update

	self._could_damage_last_update = arg_19_7

	local has_been_within_damage_window = self.has_been_within_damage_window

	has_been_within_damage_window = has_been_within_damage_window or arg_19_7
	self.has_been_within_damage_window = has_been_within_damage_window

	local unbox = self._stored_position:unbox()
	local unbox_2 = self._stored_rotation:unbox()
	local up_3 = Quaternion.up(unbox_2)
	local var_19_14 = arg_19_8
	local num_3 = Vector3(var_19_14.x, var_19_14.y, var_19_14.z - self._down_offset) + num
	local var_19_16 = arg_19_9

	self._stored_position:store(num_3)
	self._stored_rotation:store(var_19_16)

	local unbox_3 = self.stored_half_extents:unbox()
	local z = unbox_3.z
	local num_4

	if not arg_19_5.range_mod then
		num_4 = arg_19_5.range_mod * SweepRangeMod

		if not num_4 then
			-- Nothing
		end
	end

	num_4 = SweepRangeMod

	do
		local num_5
	end

	::label_19_0::

	if not arg_19_5.width_mod then
		num_5 = arg_19_5.width_mod * SweepWidthMod

		if not num_5 then
			-- Nothing
		end
	end

	num_5 = 20 * SweepWidthMod

	do
		local num_6
	end

	::label_19_1::

	if not arg_19_5.height_mod then
		num_6 = arg_19_5.height_mod * SweepHeigthMod

		if not num_6 then
			-- Nothing
		end
	end

	num_6 = 4 * SweepHeigthMod

	::label_19_2::

	local range_mod_add = arg_19_5.range_mod_add

	range_mod_add = range_mod_add or 0

	if not global_is_inside_inn then
		num_4 = 0.65 * num_4
		num_5 = num_5 / 4
	end

	local num_7 = z * num_4 + range_mod_add / 2

	unbox_3.x = unbox_3.x * num_5
	unbox_3.y = unbox_3.y * num_6
	unbox_3.z = num_7

	local var_19_24 = arg_19_9
	local num_8 = unbox + up_3 * num_7
	local num_9 = unbox + up * num_7 * 2 - Quaternion.up(unbox_2) * num_7
	local num_10 = 5
	local num_11 = 20
	local num_12 = 5
	local _calculate_attack_direction = self:_calculate_attack_direction(arg_19_5, var_19_24)
	local owner = Managers.player:owner(arg_19_4)
	local var_19_32 = Vector3(unbox_3.x, unbox_3.y, 0.0001)
	local get_difficulty_rank = Managers.state.difficulty:get_difficulty_rank()
	local str = "filter_melee_sweep"

	if not PhysicsWorld.start_reusing_sweep_tables then
		PhysicsWorld.start_reusing_sweep_tables()
	end

	local linear_obb_sweep = PhysicsWorld.linear_obb_sweep(arg_19_6, unbox, unbox + up_3 * num_7 * 2, var_19_32, unbox_2, num_10, "collision_filter", str, "report_initial_overlap")
	local linear_obb_sweep_2 = PhysicsWorld.linear_obb_sweep(arg_19_6, num_8, num_9, unbox_3, unbox_2, num_11, "collision_filter", str, "report_initial_overlap")
	local linear_obb_sweep_3 = PhysicsWorld.linear_obb_sweep(arg_19_6, unbox + up * num_7, num_3 + up * num_7, unbox_3, var_19_16, num_12, "collision_filter", str, "report_initial_overlap")
	local num_13 = 0
	local num_14 = 0
	local num_15 = 0

	if not linear_obb_sweep then
		num_13 = #linear_obb_sweep

		for i = 1, num_13 do
			tbl_2[i] = linear_obb_sweep[i]
		end
	end

	if not linear_obb_sweep_2 then
		for j = 1, #linear_obb_sweep_2 do
			local var_19_41 = linear_obb_sweep_2[j]
			local actor = var_19_41.actor
			local var_19_43

			for k = 1, num_13 do
				if tbl_2[k].actor == actor then
					var_19_43 = true

					break
				end
			end

			if not var_19_43 then
				num_14 = num_14 + 1
				tbl_2[num_13 + num_14] = var_19_41
			end
		end
	end

	if not linear_obb_sweep_3 then
		for l = 1, #linear_obb_sweep_3 do
			local var_19_44 = linear_obb_sweep_3[l]
			local actor_2 = var_19_44.actor
			local var_19_46

			for i4 = 1, num_13 + num_14 do
				if tbl_2[i4].actor == actor_2 then
					var_19_46 = true

					break
				end
			end

			if not var_19_46 then
				num_15 = num_15 + 1
				tbl_2[num_13 + num_14 + num_15] = var_19_44
			end
		end
	end

	for i5 = num_13 + num_14 + num_15 + 1, #tbl_2 do
		tbl_2[i5] = nil
	end

	local extension = ScriptUnit.extension(arg_19_4, "first_person_system")
	local has_extension = ScriptUnit.has_extension(arg_19_4, "sound_effect_system")
	local _damage_profile = self._damage_profile
	local _hit_units = self._hit_units
	local flag_3 = false
	local num_16 = num_3 + up * (num_7 * 2)
	local var_19_53

	if not self._overridable_settings.use_precision_sweep and not self._precision_target_unit then
		local check_precision_target = self:check_precision_target(arg_19_4, owner, arg_19_5.dedicated_target_range, true, num_16)

		if self._precision_target_unit ~= check_precision_target then
			var_19_53 = true
			self._precision_target_unit = nil
		end
	end

	local num_17 = num_13 + num_14 + num_15

	if not flag_2 and not self._last_potential_hit_result_has_result then
		local num_18 = 0
		local num_19 = 1

		for i6 = 1, #self._last_potential_hit_result do
			if not self._last_potential_hit_result[i6].already_hit then
				local tbl = {}

				if not self._last_potential_hit_result[i6].actor:unbox() then
					tbl.actor = self._last_potential_hit_result[i6].actor:unbox()
					tbl.position = self._last_potential_hit_result[i6].hit_position:unbox()
					tbl.normal = self._last_potential_hit_result[i6].hit_normal:unbox()

					table.insert(tbl_2, num_19, tbl)

					_hit_units[self._last_potential_hit_result[i6].hit_unit] = nil
					num_19 = num_19 + 1
					num_18 = num_18 + 1
				end
			end
		end

		num_17 = num_17 + num_18
	end

	local enemy_units_lookup = Managers.state.side.side_by_unit[arg_19_4].enemy_units_lookup
	local _this_attack_killed_enemy = self._this_attack_killed_enemy
	local camera_position_rotation, var_19_62 = extension:camera_position_rotation()

	for i7 = 1, num_17 do
		local _last_potential_hit_result_has_result = self._last_potential_hit_result_has_result
		local _has_hit_precision_target = self._has_hit_precision_target
		local flag_4 = not _last_potential_hit_result_has_result and _has_hit_precision_target and var_19_53
		local var_19_66 = tbl_2[i7]
		local actor_3 = var_19_66.actor
		local var_19_68 = _revalidate_actor_and_get_unit(actor_3)
		local position = var_19_66.position
		local normal = var_19_66.normal
		local flag_5 = false

		if not flag_4 then
			local count = #self._last_potential_hit_result

			if not var_19_53 then
				flag_5 = true
				var_19_53 = false
			elseif not self._last_potential_hit_result[count].hit_mass_budget then
				flag_5 = true
			end

			if not flag_5 then
				local unbox_4 = self._last_potential_hit_result[count].actor:unbox()

				if not unbox_4 then
					local var_19_74 = unbox_4
					local var_19_75 = _revalidate_actor_and_get_unit(var_19_74)

					if not alive(var_19_75) then
						actor_3 = var_19_74
						var_19_68 = var_19_75
						position = self._last_potential_hit_result[count].hit_position:unbox()
						normal = self._last_potential_hit_result[count].hit_normal:unbox()
						var_19_66.actor = actor_3
						var_19_66.position = position
						var_19_66.normal = normal
						_hit_units[self._last_potential_hit_result[count].hit_unit] = nil
						self._last_potential_hit_result[count].already_hit = true
					end
				end
			end

			self._last_potential_hit_result_has_result = false
		end

		local flag_6 = false

		if not alive(var_19_68) and not Vector3.is_valid(position) then
			fassert(Vector3.is_valid(position), "The hit position is not valid! Actor: %s, Unit: %s", actor_3, var_19_68)
			assert(var_19_68, "hit_unit is nil.")

			local redirect_shield_hit, var_19_78 = ActionUtils.redirect_shield_hit(var_19_68, actor_3)
			local unit_breed = AiUtils.unit_breed(redirect_shield_hit)
			local flag_7 = false
			local is_within_custom_view = extension:is_within_custom_view(position, camera_position_rotation, var_19_62, degrees_to_radians, degrees_to_radians_2)
			local flag_8 = unit_breed ~= nil
			local flag_9 = not unit_breed and unit_breed.is_hero
			local flag_10

			flag_10 = not unit_breed and unit_breed.is_ai

			local flag_11 = redirect_shield_hit == arg_19_4
			local flag_12 = not enemy_units_lookup[redirect_shield_hit]
			local flag_13 = false
			local flag_14 = false

			if not unit_breed and not unit_breed.can_dodge then
				flag_7 = AiUtils.attack_is_dodged(redirect_shield_hit)
			end

			if not (not flag_8 and flag_12 and flag_11 and not is_within_custom_view and flag_4 and self._hit_units[redirect_shield_hit] ~= nil) then
				_hit_units[redirect_shield_hit] = true

				local _status_extension = self._status_extension

				flag_13 = flag_7 or not not self._unlimited_cleave or not AiUtils.attack_is_shield_blocked(redirect_shield_hit, arg_19_4) or not not arg_19_5.ignore_armour_hit or not _status_extension:is_invisible()

				if not flag_9 then
					flag_14 = ScriptUnit.extension(redirect_shield_hit, "status_system"):is_blocking()
				end

				local flag_15 = false
				local flag_16 = false
				local unit_game_object_id = _network_manager:unit_game_object_id(redirect_shield_hit)
				local num_20 = 1
				local var_19_94

				if not (not self._overridable_settings.use_precision_sweep and self._precision_target_unit == nil or self._has_hit_precision_target or flag_2) then
					if redirect_shield_hit == self._precision_target_unit then
						self._has_hit_precision_target = true
						num_20, flag_13, flag_15, flag_16 = self:_calculate_hit_mass(get_difficulty_rank, num_20, flag_13, arg_19_5, unit_breed, unit_game_object_id, redirect_shield_hit)
						var_19_94 = _damage_profile.default_target
					elseif not HEALTH_ALIVE[redirect_shield_hit] then
						local _get_target_hit_mass = self:_get_target_hit_mass(get_difficulty_rank, flag_13, arg_19_5, unit_breed, unit_game_object_id, redirect_shield_hit)
						local num_21 = self._number_of_potential_hit_results + 1
						local tbl_3 = {}

						self._last_potential_hit_result_has_result = true
						tbl_3.hit_unit = redirect_shield_hit
						tbl_3.actor = ActorBox(var_19_78)
						tbl_3.hit_position = Vector3Box(position)
						tbl_3.hit_normal = Vector3Box(normal)
						tbl_3.hit_mass_budget = self._max_targets - (self._amount_of_mass_hit + _get_target_hit_mass) >= 0
						self._last_potential_hit_result[num_21] = tbl_3
						self._number_of_potential_hit_results = num_21
					end
				elseif self._amount_of_mass_hit < self._max_targets or not flag_4 then
					if not flag_12 then
						num_20, flag_13, flag_15, flag_16 = self:_calculate_hit_mass(get_difficulty_rank, num_20, flag_13, arg_19_5, unit_breed, unit_game_object_id, redirect_shield_hit)
					end

					local targets = _damage_profile.targets

					var_19_94 = not targets and targets[num_20] and _damage_profile.default_target
				end

				if not var_19_94 then
					local _owner_buff_extension = self._owner_buff_extension
					local _damage_profile_id = self._damage_profile_id
					local var_19_101

					if not unit_breed then
						local var_19_102 = node_2(var_19_78)

						var_19_101 = unit_breed.hit_zones_lookup[var_19_102].name

						if var_19_101 == "afro" then
							var_19_101 = "torso"
						end

						flag_6 = not HEALTH_ALIVE[redirect_shield_hit] and unit_breed.armor_category == 2 and unit_breed.stagger_armor_category == 2 and unit_breed.armor_category == 3
					else
						var_19_101 = "torso"
					end

					local flag_17 = (not not self._unlimited_cleave or self._number_of_hit_enemies >= self._max_targets or self._amount_of_mass_hit >= self._max_targets or not flag_6) and not not self._overridable_settings.slide_armour_hit or not arg_19_5.ignore_armour_hit

					if not flag_13 then
						flag_17 = (not not self._unlimited_cleave or self._amount_of_mass_hit + 3 >= self._max_targets or not flag_6) and not not self._overridable_settings.slide_armour_hit or not arg_19_5.ignore_armour_hit
					end

					if not has_extension and not HEALTH_ALIVE[redirect_shield_hit] then
						has_extension:add_hit()
					end

					local item_name = self.item_name
					local var_19_105 = NetworkLookup.damage_sources[item_name]
					local unit_game_object_id_2 = _network_manager:unit_game_object_id(arg_19_4)
					local var_19_107 = NetworkLookup.hit_zones[var_19_101]
					local is_server = self.is_server
					local _check_backstab = self:_check_backstab(unit_breed, redirect_shield_hit, arg_19_4, _owner_buff_extension, extension)
					local flag_18 = flag_13 or flag_14

					if not (not unit_breed and flag_7) then
						local _get_power_boost, var_19_112 = self:_get_power_boost()
						local _power_level = self._power_level
						local _is_critical_strike = self._is_critical_strike

						_is_critical_strike = _is_critical_strike or _get_power_boost

						local _play_character_impact = self:_play_character_impact(is_server, arg_19_4, redirect_shield_hit, unit_breed, position, var_19_101, arg_19_5, _damage_profile, num_20, _power_level, _calculate_attack_direction, flag_18, var_19_112, _is_critical_strike, _check_backstab)

						_this_attack_killed_enemy = _this_attack_killed_enemy or _play_character_impact
					end

					local armor_category = unit_breed.armor_category

					self:_play_hit_animations(arg_19_4, arg_19_5, flag_17, var_19_101, armor_category, flag_18, _this_attack_killed_enemy)

					if not flag_7 then
						flag_17 = false
					end

					if not (not Managers.state.controller_features and not self.owner.local_player and self._has_played_rumble_effect) then
						if not flag_6 then
							Managers.state.controller_features:add_effect("rumble", {
								rumble_effect = "hit_armor"
							})
						else
							local hit_rumble_effect = arg_19_5.hit_rumble_effect

							hit_rumble_effect = hit_rumble_effect or "hit_character"

							Managers.state.controller_features:add_effect("rumble", {
								rumble_effect = hit_rumble_effect
							})
						end

						if not flag_17 then
							self._has_played_rumble_effect = true
						end
					end

					local _get_power_boost_2, var_19_119 = self:_get_power_boost()
					local _power_level_2 = self._power_level
					local _is_critical_strike_2 = self._is_critical_strike

					_is_critical_strike_2 = _is_critical_strike_2 or _get_power_boost_2

					local charge_value = _damage_profile.charge_value
					local flag_19 = false
					local str_2 = "no_buff"

					if flag_13 or not flag_14 then
						if (charge_value ~= "heavy_attack" or not _owner_buff_extension:has_buff_perk("shield_break")) and not _owner_buff_extension:has_buff_perk("potion_armor_penetration") then
							flag_19 = true
						end

						local shield_break

						if not unit_breed.unbreakable_shield then
							shield_break = _damage_profile.shield_break

							if not shield_break then
								shield_break = flag_19
							end
						else
							shield_break = false
						end

						if false then
							shield_break = true
						end

						DamageUtils.handle_hit_indication(arg_19_4, redirect_shield_hit, 0, var_19_101, false, not shield_break, shield_break)
					else
						local flag_20 = true
						local _number_of_hit_enemies = self._number_of_hit_enemies
						local get_item_buff_type = DamageUtils.get_item_buff_type(self.item_name)

						str_2 = DamageUtils.buff_on_attack(arg_19_4, redirect_shield_hit, charge_value, _is_critical_strike_2, var_19_101, _number_of_hit_enemies, flag_20, get_item_buff_type, nil, item_name)

						local var_19_129 = NetworkLookup.attack_templates[var_19_94.attack_template]

						weapon_system:rpc_weapon_blood(nil, unit_game_object_id_2, var_19_129)

						local var_19_130 = Vector3(var_19_66.position.x, var_19_66.position.y, var_19_66.position.z + self._down_offset)

						Managers.state.blood:add_enemy_blood(var_19_130, redirect_shield_hit)
					end

					if str_2 ~= "killing_blow" then
						self:_send_attack_hit(arg_19_2, var_19_105, unit_game_object_id_2, unit_game_object_id, var_19_107, position, _calculate_attack_direction, _damage_profile_id, "power_level", _power_level_2, "hit_target_index", num_20, "blocking", flag_13 or flag_14, "shield_break_procced", flag_19, "boost_curve_multiplier", var_19_119, "is_critical_strike", _is_critical_strike_2, "can_damage", flag_15, "can_stagger", flag_16, "backstab_multiplier", _check_backstab, "first_hit", self._number_of_hit_enemies == 1)

						if not (flag_18 or self.is_server) then
							local var_19_131 = NetworkLookup.attack_templates[var_19_94.attack_template]

							_network_manager.network_transmit:send_rpc_server("rpc_weapon_blood", unit_game_object_id_2, var_19_131)
						end

						flow_event(self.first_person_unit, "sfx_swing_hit")

						if not arg_19_5.add_fatigue_on_hit then
							self:_handle_fatigue(_owner_buff_extension, self._status_extension, arg_19_5, false)
						end
					else
						extension:play_hud_sound_event("Play_hud_matchmaking_countdown")
					end

					if not arg_19_5.knockback_data then
						local has_extension_2 = ScriptUnit.has_extension(redirect_shield_hit, "status_system")

						if not (not has_extension_2 and has_extension_2:is_knocked_down()) then
							self:_push_target(arg_19_4, redirect_shield_hit, arg_19_5.knockback_data, flag_18, flag_9)
						end
					end

					if not flag_17 then
						break
					end
				end
			elseif flag_8 or not is_within_custom_view then
				if not ScriptUnit.has_extension(redirect_shield_hit, "ai_inventory_item_system") then
					if not self._hit_units[redirect_shield_hit] then
						flow_event(redirect_shield_hit, "break_shield")

						self._hit_units[redirect_shield_hit] = true
					end

					if not (not Managers.state.controller_features and not self.owner.local_player and self._has_played_rumble_effect) then
						Managers.state.controller_features:add_effect("rumble", {
							rumble_effect = "hit_shield"
						})

						self._has_played_rumble_effect = true
					end
				elseif _hit_units[redirect_shield_hit] ~= nil or not ScriptUnit.has_extension(redirect_shield_hit, "health_system") then
					local game_object_or_level_id, var_19_134 = Managers.state.network:game_object_or_level_id(redirect_shield_hit)

					if not var_19_134 then
						self:hit_level_object(_hit_units, redirect_shield_hit, arg_19_4, arg_19_5, position, _calculate_attack_direction, game_object_or_level_id)
						self:_play_environmental_effect(arg_19_9, arg_19_5, redirect_shield_hit, position, normal, var_19_78)

						flag = true
					else
						self._hit_units[redirect_shield_hit] = redirect_shield_hit

						local ceil = math.ceil(self._amount_of_mass_hit + 1)
						local item_name_2 = self.item_name
						local var_19_137 = NetworkLookup.damage_sources[item_name_2]
						local unit_game_object_id_3 = _network_manager:unit_game_object_id(arg_19_4)
						local unit_game_object_id_4 = _network_manager:unit_game_object_id(redirect_shield_hit)
						local full = NetworkLookup.hit_zones.full
						local _damage_profile_id_2 = self._damage_profile_id
						local _get_power_boost_3, var_19_143 = self:_get_power_boost()
						local _power_level_3 = self._power_level
						local _is_critical_strike_3 = self._is_critical_strike

						_is_critical_strike_3 = _is_critical_strike_3 or _get_power_boost_3

						if get_data(redirect_shield_hit, "allow_melee_damage") ~= false then
							self:_send_attack_hit(arg_19_2, var_19_137, unit_game_object_id_3, unit_game_object_id_4, full, position, _calculate_attack_direction, _damage_profile_id_2, "power_level", _power_level_3, "hit_target_index", ceil, "blocking", flag_13, "boost_curve_multiplier", var_19_143, "is_critical_strike", _is_critical_strike_3)

							local flag_21 = not get_data(redirect_shield_hit, "weapon_hit_through")

							self:_play_hit_animations(arg_19_4, arg_19_5, flag_21)
							self:_play_environmental_effect(arg_19_9, arg_19_5, redirect_shield_hit, position, normal, var_19_78)

							flag = true
						end
					end
				elseif _hit_units[redirect_shield_hit] == nil then
					if not global_is_inside_inn then
						local flag_22 = true

						self:_play_hit_animations(arg_19_4, arg_19_5, flag_22)
					end

					flag_3 = i7
					flag = true
				end
			end

			if flag_13 or not flag_14 then
				self._amount_of_mass_hit = self._amount_of_mass_hit + 3
			end
		end
	end

	self._this_attack_killed_enemy = _this_attack_killed_enemy

	if not (not flag_3 and self._has_hit_environment or not (num_13 + num_14 > 0)) then
		self._has_hit_environment = true

		local var_19_148 = tbl_2[flag_3]
		local actor_4 = var_19_148.actor
		local var_19_150 = _revalidate_actor_and_get_unit(actor_4)

		if not (not alive(var_19_150) and arg_19_3 == var_19_150) then
			local position_2 = var_19_148.position
			local normal_2 = var_19_148.normal
			local var_19_153 = _calculate_attack_direction

			self:_play_environmental_effect(arg_19_9, arg_19_5, var_19_150, position_2, normal_2, actor_4)

			if not (not Managers.state.controller_features and not global_is_inside_inn and not self.owner.local_player and self._has_played_rumble_effect) then
				Managers.state.controller_features:add_effect("rumble", {
					rumble_effect = "hit_environment"
				})

				self._has_played_rumble_effect = true
			end

			if not var_19_150 and not alive(var_19_150) and not actor_4 then
				set_flow_variable(var_19_150, "hit_actor", actor_4)
				set_flow_variable(var_19_150, "hit_direction", var_19_153)
				set_flow_variable(var_19_150, "hit_position", position_2)
				flow_event(var_19_150, "lua_simple_damage")
			end
		end
	end

	if not flag_2 then
		self._attack_aborted = true
	end

	if not (not Managers.state.controller_features and not global_is_inside_inn and not flag and not self.owner.local_player and self._has_played_rumble_effect) then
		Managers.state.controller_features:add_effect("rumble", {
			rumble_effect = "hit_environment"
		})

		self._has_played_rumble_effect = true
	end

	if not PhysicsWorld.stop_reusing_sweep_tables then
		PhysicsWorld.stop_reusing_sweep_tables()
	end
end

ActionSweep._push_target = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	-- function 20
	local catapult = arg_20_3.catapult
	local catapult_players = arg_20_3.catapult_players

	if not catapult then
		if not catapult_players and not arg_20_5 then
			local player_catapult_speed = arg_20_3.player_catapult_speed
			local player_catapult_speed_z = arg_20_3.player_catapult_speed_z

			if not arg_20_4 then
				player_catapult_speed = arg_20_3.player_catapult_speed_blocked
				player_catapult_speed_z = arg_20_3.player_catapult_speed_blocked_z
			end

			local var_20_4 = POSITION_LOOKUP[arg_20_1]
			local num = POSITION_LOOKUP[arg_20_2] - var_20_4
			local num_2 = player_catapult_speed * Vector3.normalize(num)

			if not player_catapult_speed_z then
				Vector3.set_z(num_2, player_catapult_speed_z)
			end

			if not catapult_players then
				StatusUtils.set_catapulted_network(arg_20_2, true, num_2)
			end
		end
	else
		local player_knockback_speed = arg_20_3.player_knockback_speed

		if not arg_20_4 then
			player_knockback_speed = arg_20_3.player_knockback_speed_blocked
		end

		local var_20_8 = POSITION_LOOKUP[arg_20_1]
		local num_3 = POSITION_LOOKUP[arg_20_2] - var_20_8
		local num_4 = player_knockback_speed * Vector3.normalize(num_3)

		ScriptUnit.extension(arg_20_2, "locomotion_system"):add_external_velocity(num_4)
	end
end

ActionSweep._play_environmental_effect = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6)
	-- function 21
	local forward = Quaternion.forward(arg_21_1)
	local right = Quaternion.right(arg_21_1)
	local up = Quaternion.up(arg_21_1)
	local world = self.world
	local unbox

	if not arg_21_2.impact_axis then
		unbox = arg_21_2.impact_axis:unbox()

		if not unbox then
			-- Nothing
		end
	end

	unbox = Vector3.forward()

	::label_21_0::

	local hit_effect = self._overridable_settings.hit_effect
	local num = right * unbox.x + forward * unbox.y + up * unbox.z
	local look = Quaternion.look(num, -right)
	local owner_unit = self.owner_unit
	local bot_player = Managers.player:owner(owner_unit).bot_player

	EffectHelper.play_surface_material_effects(hit_effect, world, arg_21_3, arg_21_4, look, arg_21_5, nil, bot_player, nil, arg_21_6)

	if not Managers.state.network:game() then
		EffectHelper.remote_play_surface_material_effects(hit_effect, world, arg_21_3, arg_21_4, look, arg_21_5, self.is_server, arg_21_6)
	end
end

local tbl_3 = {
	javelin_stab_hit = "stab_hit",
	slashing_hit = "slashing_hit",
	stab_hit = "stab_hit",
	slashing_dagger_hit = "slashing_hit",
	Play_weapon_fire_torch_flesh_hit = "burning_hit",
	axe_boss_1h_hit = "axe_boss_1h_hit",
	hammer_2h_hit = "blunt_hit",
	axe_2h_hit = "slashing_hit",
	crowbill_stab_hit = "stab_hit",
	axe_1h_hit = "slashing_hit",
	blunt_hit = "blunt_hit"
}

ActionSweep._play_character_impact = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7, arg_22_8, arg_22_9, arg_22_10, arg_22_11, arg_22_12, arg_22_13, arg_22_14, arg_22_15)
	-- function 22
	local bot_player = Managers.player:owner(arg_22_2).bot_player
	local world = self.world
	local owner_unit = self.owner_unit
	local var_22_3

	if not arg_22_8.targets then
		var_22_3 = arg_22_8.targets[arg_22_9]

		if not var_22_3 then
			-- Nothing
		end
	end

	var_22_3 = arg_22_8.default_target

	::label_22_0::

	local attack_template = var_22_3.attack_template
	local get_attack_template = DamageUtils.get_attack_template(attack_template)
	local num = 0
	local flag = false

	if not var_22_3 then
		local item_name = self.item_name
		local var_22_9 = BoostCurves[var_22_3.boost_curve_type]

		num, flag = DamageUtils.calculate_damage(DamageOutput, arg_22_3, arg_22_2, arg_22_6, arg_22_10, var_22_9, arg_22_13, arg_22_14, arg_22_8, arg_22_9, arg_22_15, item_name)
	end

	local flag_2 = num <= 0
	local hitzone_armor_categories = arg_22_4.hitzone_armor_categories
	local var_22_12

	if not hitzone_armor_categories then
		var_22_12 = hitzone_armor_categories[arg_22_6]

		if not var_22_12 then
			-- Nothing
		end
	end

	var_22_12 = arg_22_4.armor_category

	do
		local stagger_impact_sound_event
	end

	::label_22_1::

	if not flag_2 then
		stagger_impact_sound_event = arg_22_7.stagger_impact_sound_event

		if not stagger_impact_sound_event then
			-- Nothing
		end
	end

	stagger_impact_sound_event = self._overridable_settings.impact_sound_event

	::label_22_2::

	if not arg_22_12 then
		if tbl_3[stagger_impact_sound_event] == "blunt_hit" then
			stagger_impact_sound_event = arg_22_4.shield_blunt_block_sound or "blunt_hit_shield_wood"
		elseif tbl_3[stagger_impact_sound_event] == "slashing_hit" then
			stagger_impact_sound_event = arg_22_4.shield_slashing_block_sound or "slashing_hit_shield_wood"
		elseif tbl_3[stagger_impact_sound_event] == "stab_hit" then
			stagger_impact_sound_event = arg_22_4.shield_stab_block_sound or "stab_hit_shield_wood"
		elseif tbl_3[stagger_impact_sound_event] == "burning_hit" then
			stagger_impact_sound_event = arg_22_4.shield_stab_block_sound or "Play_weapon_fire_torch_wood_shield_hit"
		elseif tbl_3[stagger_impact_sound_event] == "axe_boss_1h_hit" then
			stagger_impact_sound_event = arg_22_4.boss_blocked_sound or "slashing_hit_shield_wood"
		end
	elseif var_22_12 == 2 then
		stagger_impact_sound_event = not flag_2 and self._overridable_settings.no_damage_impact_sound_event and arg_22_7.armor_impact_sound_event or self._overridable_settings.impact_sound_event
	end

	local str = "default"
	local var_22_15

	if not arg_22_12 then
		if not arg_22_4.blocking_hit_effect then
			var_22_15 = arg_22_4.blocking_hit_effect
		else
			var_22_15 = var_22_12 ~= 2 or not "fx/hit_enemy_shield_metal" or "fx/hit_enemy_shield"
		end

		str = "no_damage"
	elseif not flag then
		var_22_15 = "fx/hit_enemy_shield_metal"
	elseif not (not str and str ~= "no_damage") then
		var_22_15 = arg_22_7.no_damage_impact_particle_effect
	elseif not (not (num <= 0) or var_22_12 ~= 2) then
		var_22_15 = arg_22_7.armour_impact_particle_effect or "fx/hit_armored"
	elseif num <= 0 then
		var_22_15 = arg_22_7.no_damage_impact_particle_effect
	elseif not arg_22_4.no_blood_splatter_on_damage then
		var_22_15 = arg_22_7.impact_particle_effect or BloodSettings:get_hit_effect_for_race(arg_22_4.race) or arg_22_4.hit_effect

		EffectHelper.player_critical_hit(world, arg_22_14, arg_22_2, arg_22_3, arg_22_5)
	end

	local additional_hit_effects = arg_22_7.additional_hit_effects

	if not additional_hit_effects then
		for i = 1, #additional_hit_effects do
			EffectHelper.player_melee_hit_particles(world, additional_hit_effects[i], arg_22_5, arg_22_11, str, arg_22_3, num)
		end
	end

	if num <= 0 then
		str = "no_damage"
	end

	if not var_22_15 then
		EffectHelper.player_melee_hit_particles(world, var_22_15, arg_22_5, arg_22_11, str, arg_22_3, num)
	end

	if arg_22_6 == "head" or arg_22_6 == "neck" or not get_attack_template.headshot_sound then
		stagger_impact_sound_event = get_attack_template.headshot_sound
	end

	if not flag then
		stagger_impact_sound_event = "enemy_grudge_deflect"

		DamageUtils.handle_hit_indication(self.owner_unit, arg_22_3, 0, arg_22_6, false, true)
	end

	local sound_type = get_attack_template.sound_type

	if not stagger_impact_sound_event then
		if not sound_type then
			return
		end

		EffectHelper.play_melee_hit_effects(stagger_impact_sound_event, world, arg_22_5, sound_type, bot_player, arg_22_3)

		local network = Managers.state.network
		local var_22_19 = NetworkLookup.sound_events[stagger_impact_sound_event]
		local var_22_20 = NetworkLookup.melee_impact_sound_types[sound_type]
		local unit_game_object_id = network:unit_game_object_id(arg_22_3)

		if not arg_22_1 then
			network.network_transmit:send_rpc_clients("rpc_play_melee_hit_effects", var_22_19, arg_22_5, var_22_20, unit_game_object_id)
		else
			network.network_transmit:send_rpc_server("rpc_play_melee_hit_effects", var_22_19, arg_22_5, var_22_20, unit_game_object_id)
		end
	else
		Application.warning("[ActionSweep] Missing sound event for sweep action in unit %q.", self.weapon_unit)
	end

	local get_breed_damage_multiplier_type = DamageUtils.get_breed_damage_multiplier_type(arg_22_4, arg_22_6)

	if get_breed_damage_multiplier_type == "headshot" or get_breed_damage_multiplier_type ~= "weakspot" or not arg_22_12 or arg_22_7.no_headshot_sound or not HEALTH_ALIVE[arg_22_3] then
		ScriptUnit.extension(owner_unit, "first_person_system"):play_hud_sound_event("Play_hud_melee_headshot", nil, false)
	end

	local on_hit_hud_sound_event = arg_22_7.on_hit_hud_sound_event

	if not on_hit_hud_sound_event then
		ScriptUnit.extension(owner_unit, "first_person_system"):play_hud_sound_event(on_hit_hud_sound_event, nil, false)
	end

	local flag_3 = num >= ScriptUnit.extension(arg_22_3, "health_system"):current_health()
	local has_extension = ScriptUnit.has_extension(self.owner_unit, "sound_effect_system")

	if not has_extension and not flag_3 then
		has_extension:melee_kill()
	end

	if not arg_22_12 and not arg_22_4.play_hit_reacts_when_blocking then
		DamageUtils.add_hit_reaction(arg_22_3, arg_22_4, bot_player, arg_22_11, flag_3)
	end

	if not arg_22_12 then
		return false
	end

	return flag_3
end

ActionSweep.hit_level_object = function (self, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6, arg_23_7, arg_23_8)
	-- function 23
	arg_23_1[arg_23_2] = true
	self._has_hit_environment = true

	local str = "full"

	self._amount_of_mass_hit = self._amount_of_mass_hit + 1

	local ceil = math.ceil(self._amount_of_mass_hit)
	local _damage_profile = self._damage_profile
	local item_name = self.item_name
	local _get_power_boost, var_23_5 = self:_get_power_boost()
	local _power_level = self._power_level
	local _is_critical_strike = self._is_critical_strike

	_is_critical_strike = _is_critical_strike or _get_power_boost

	DamageUtils.damage_level_unit(arg_23_2, arg_23_3, str, _power_level, var_23_5, _is_critical_strike, _damage_profile, ceil, arg_23_6, item_name)

	local first_person_hit_anim = arg_23_4.first_person_hit_anim

	if not first_person_hit_anim then
		local get_first_person_unit = ScriptUnit.extension(arg_23_3, "first_person_system"):get_first_person_unit()

		animation_event(get_first_person_unit, first_person_hit_anim)
	end
end

ActionSweep.finish = function (self, arg_24_1, arg_24_2)
	-- function 24
	local _current_action = self._current_action

	if arg_24_1 == "new_interupting_action" then
		local current_time_in_action = self.current_time_in_action

		current_time_in_action = current_time_in_action or 0

		local _dt = self._dt
		local time = Managers.time:time("game")

		self:_update_sweep(_dt * 2, time, _current_action, current_time_in_action - _dt)
	end

	if arg_24_1 == "interacting" then
		flow_event(self.weapon_unit, "lua_finish_interacting")
	end

	local owner_unit = self.owner_unit
	local action_aborted_flow_event = _current_action.action_aborted_flow_event

	if not (not action_aborted_flow_event and self.action_aborted_flow_event_sent) then
		flow_event(self.weapon_unit, action_aborted_flow_event)
	end

	self.action_aborted_flow_event_sent = nil

	if not _current_action.keep_block then
		local flag = not arg_24_2 and arg_24_2.new_action_settings

		if not (not flag and flag.keep_block) then
			if not LEVEL_EDITOR_TEST then
				local go_id = Managers.state.unit_storage:go_id(owner_unit)

				if not self.is_server then
					Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", go_id, false)
				else
					Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", go_id, false)
				end
			end

			ScriptUnit.extension(owner_unit, "status_system"):set_blocking(false)
		end
	end

	local _owner_hud_extension = self._owner_hud_extension

	if not _owner_hud_extension then
		_owner_hud_extension.show_critical_indication = false
	end

	local extension = ScriptUnit.extension(owner_unit, "first_person_system")

	extension:enable_rig_movement()

	if not self._is_critical_strike then
		local str = "Stop_player_combat_crit_swing_2D"

		extension:play_hud_sound_event(str, nil, false)
	end
end

ActionSweep.destroy = function (arg_25_0)
	-- function 25
	return
end

ActionSweep._play_hit_animations = function (self, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5, arg_26_6, arg_26_7)
	-- function 26
	local var_26_0

	if not arg_26_2.dual_hit_stop_anims and not self._action_hand then
		var_26_0 = arg_26_2.dual_hit_stop_anims[self._action_hand]

		if not var_26_0 then
			-- Nothing
		end
	end

	var_26_0 = self._overridable_settings.hit_stop_anim

	do
		local hit_stop_kill_anim
	end

	::label_26_0::

	if not arg_26_3 and not arg_26_7 then
		hit_stop_kill_anim = arg_26_2.hit_stop_kill_anim

		if not hit_stop_kill_anim then
			-- Nothing
		end
	end

	if arg_26_4 == "head" or arg_26_5 ~= 2 or not arg_26_3 then
		hit_stop_kill_anim = arg_26_2.hit_armor_anim

		if not hit_stop_kill_anim then
			-- Nothing
		end
	end

	if not arg_26_3 and not arg_26_6 then
		hit_stop_kill_anim = arg_26_2.hit_shield_stop_anim

		if not hit_stop_kill_anim then
			-- Nothing
		end
	end

	hit_stop_kill_anim = not arg_26_3 and var_26_0 and arg_26_2.first_person_hit_anim

	::label_26_1::

	local flag = not arg_26_3 and self._overridable_settings.hit_stop_anim
	local _attack_aborted = self._attack_aborted

	_attack_aborted = _attack_aborted or arg_26_3
	self._attack_aborted = _attack_aborted

	if not hit_stop_kill_anim then
		local get_first_person_unit = ScriptUnit.extension(arg_26_1, "first_person_system"):get_first_person_unit()

		animation_event(get_first_person_unit, hit_stop_kill_anim)
	end

	local action_aborted_flow_event = arg_26_2.action_aborted_flow_event

	if not action_aborted_flow_event and not arg_26_3 then
		self.action_aborted_flow_event_sent = true

		flow_event(self.weapon_unit, action_aborted_flow_event)
	end

	if not flag then
		CharacterStateHelper.play_animation_event(arg_26_1, flag)
	end
end

ActionSweep._get_damage_profile_name = function (self, arg_27_1, arg_27_2)
	-- function 27
	local var_27_0

	if not arg_27_1 then
		var_27_0 = arg_27_2["damage_profile_" .. arg_27_1]

		if not var_27_0 then
			-- Nothing
		end
	end

	var_27_0 = self._overridable_settings.damage_profile
	var_27_0 = var_27_0 or "default"

	::label_27_0::

	return var_27_0
end

ActionSweep._populate_sweep_action_data = function (self, arg_28_1, arg_28_2)
	-- function 28
	local _overridable_settings = self._overridable_settings

	table.clear(self._overridable_settings)

	for i = 1, count do
		local var_28_1 = tbl[i]
		local var_28_2

		if not arg_28_2 then
			var_28_2 = arg_28_2[var_28_1]

			if not var_28_2 then
				-- Nothing
			end
		end

		var_28_2 = arg_28_1[var_28_1]

		::label_28_0::

		_overridable_settings[var_28_1] = var_28_2
	end
end

ActionSweep._weapon_sweep_rotation = function (arg_29_0, arg_29_1, arg_29_2)
	-- function 29
	local var_29_0 = world_rotation(arg_29_2, 0)
	local sweep_rotation_offset = arg_29_1.sweep_rotation_offset

	if not sweep_rotation_offset then
		local var_29_2 = var_29_0
		local multiply = Quaternion.multiply
		local axis_angle = Quaternion.axis_angle
		local up = Quaternion.up(var_29_0)
		local yaw = sweep_rotation_offset.yaw

		yaw = yaw or 0

		local var_29_7 = multiply(axis_angle(up, yaw), var_29_2)
		local multiply_2 = Quaternion.multiply
		local axis_angle_2 = Quaternion.axis_angle
		local right = Quaternion.right(var_29_0)
		local pitch = sweep_rotation_offset.pitch

		pitch = pitch or 0

		local var_29_12 = multiply_2(axis_angle_2(right, pitch), var_29_7)
		local multiply_3 = Quaternion.multiply
		local axis_angle_3 = Quaternion.axis_angle
		local forward = Quaternion.forward(var_29_0)
		local roll = sweep_rotation_offset.roll

		roll = roll or 0
		var_29_0 = multiply_3(axis_angle_3(forward, roll), var_29_12)
	end

	return var_29_0
end
