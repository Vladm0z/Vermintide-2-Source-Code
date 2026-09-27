-- chunkname: @scripts/unit_extensions/smart_targeting/player_unit_smart_targeting_extension.lua

local POSITION_LOOKUP = POSITION_LOOKUP
local flag = false
local flag_2 = false
local flag_3 = false
local num = 0.1
local num_2 = 8
local flag_4 = true

PlayerUnitSmartTargetingExtension = class(PlayerUnitSmartTargetingExtension)

PlayerUnitSmartTargetingExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.unit = arg_1_2
	self.world = arg_1_1.world
	self.conflict_manager = Managers.state.conflict
	self.player = arg_1_3.player

	local side = arg_1_3.side

	self._target_broadphase_categories = not side and side.enemy_broadphase_categories
	self.targeting_data = {}
	self.move_time = 0
	self.clicking = false
	self.target_unit = nil
	self._gui = World.create_screen_gui(self.world, "immediate")
	self.use_score_modifiers_1 = true
	self.score_modifiers_1 = {}
	self.score_modifiers_2 = {}
end

PlayerUnitSmartTargetingExtension.extensions_ready = function (self)
	-- function 2
	local unit = self.unit

	self.first_person_extension = ScriptUnit.extension(unit, "first_person_system")
	self.status_extension = ScriptUnit.extension(unit, "status_system")
	self.inventory_extension = ScriptUnit.extension(unit, "inventory_system")
	self.input_extension = ScriptUnit.extension(unit, "input_system")
end

local tbl = {}
local tbl_2 = {}
local tbl_3 = {}

PlayerUnitSmartTargetingExtension.update_opt2 = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	if not flag_3 then
		return
	end

	table.clear(self.targeting_data)

	local get_data = Unit.get_data
	local has_extension = ScriptUnit.has_extension
	local min = math.min
	local res_w = RESOLUTION_LOOKUP.res_w
	local res_h = RESOLUTION_LOOKUP.res_h
	local num = res_w / 2
	local num_2 = res_h / 2
	local num_3 = 8 * (res_w / 1280)
	local input_extension = self.input_extension
	local first_person_extension = self.first_person_extension
	local inventory_extension = self.inventory_extension
	local _get_player_camera = self:_get_player_camera()
	local current_position = first_person_extension:current_position()
	local current_rotation = first_person_extension:current_rotation()
	local forward = Quaternion.forward(current_rotation)
	local right = Quaternion.right(current_rotation)
	local var_3_16
	local equipment = inventory_extension:equipment()
	local right_hand_wielded_unit = equipment.right_hand_wielded_unit

	right_hand_wielded_unit = right_hand_wielded_unit or equipment.left_hand_wielded_unit

	if not Unit.alive(right_hand_wielded_unit) then
		local extension = ScriptUnit.extension(right_hand_wielded_unit, "weapon_system")

		if not extension:has_current_action() then
			var_3_16 = extension:get_current_action_settings()
		end
	end

	local get_wielded_slot_item_template = inventory_extension:get_wielded_slot_item_template()
	local var_3_21

	if not var_3_16 and not var_3_16.aim_assist_settings then
		var_3_21 = var_3_16.aim_assist_settings
	else
		var_3_21 = not get_wielded_slot_item_template and get_wielded_slot_item_template.aim_assist_settings
	end

	local get_loaded_projectile_settings = inventory_extension:get_loaded_projectile_settings()
	local speed

	if not get_loaded_projectile_settings then
		speed = get_loaded_projectile_settings.speed

		if not speed then
			-- Nothing
		end
	end

	speed = 0

	do
		local drop_multiplier
	end

	::label_3_0::

	if not get_loaded_projectile_settings then
		drop_multiplier = get_loaded_projectile_settings.drop_multiplier

		if not drop_multiplier then
			-- Nothing
		end
	end

	drop_multiplier = 0

	do
		local _gui
	end

	::label_3_1::

	if not flag then
		_gui = self._gui

		if not _gui then
			-- Nothing
		end
	end

	_gui = nil

	::label_3_2::

	local is_device_active = Managers.input:is_device_active("gamepad")
	local flag_2 = not Application.user_setting("gamepad_auto_aim_enabled")

	if not var_3_21 and not is_device_active and not flag_2 then
		return
	end

	local max_range = var_3_21.max_range
	local effective_max_range = var_3_21.effective_max_range
	local broadphase = Managers.state.entity:system("ai_system").broadphase

	table.clear(tbl)
	table.clear(tbl_2)
	table.clear(tbl_3)

	local smart_targeting_query = EngineOptimized.smart_targeting_query(broadphase, current_position, forward, 1.5, max_range, 0.1, 0.2, 0.8, 5, tbl, tbl_2, tbl_3, self._target_broadphase_categories)
	local num_4 = 0
	local var_3_33
	local num_5 = 0
	local var_3_35
	local var_3_36

	if not self.use_score_modifiers_1 then
		var_3_35 = self.score_modifiers_1
		var_3_36 = self.score_modifiers_2
	else
		var_3_35 = self.score_modifiers_2
		var_3_36 = self.score_modifiers_1
	end

	local flag_4 = false
	local num_6 = 0.8

	for i = 1, smart_targeting_query do
		repeat
			local var_3_39 = tbl[i]

			if not HEALTH_ALIVE[var_3_39] then
				break
			end

			local var_3_40 = get_data(var_3_39, "breed")
			local smart_targeting_width = var_3_40.smart_targeting_width

			if not (var_3_40.no_autoaim or smart_targeting_width) then
				break
			end

			flag_4 = true

			local var_3_42 = var_3_21.breed_scalars[var_3_40.name]

			var_3_42 = var_3_42 or 1

			if var_3_42 == 0 then
				break
			end

			local var_3_43 = tbl_2[i]
			local var_3_44 = tbl_3[i]
			local smart_targeting_outer_width = var_3_40.smart_targeting_outer_width

			smart_targeting_outer_width = smart_targeting_outer_width or smart_targeting_width * 2

			local smart_targeting_height_multiplier = var_3_40.smart_targeting_height_multiplier

			smart_targeting_height_multiplier = smart_targeting_height_multiplier or 1

			local var_3_47 = has_extension(var_3_39, "locomotion_system")
			local current_velocity

			if not var_3_47 then
				current_velocity = var_3_47:current_velocity()

				if not current_velocity then
					-- Nothing
				end
			end

			current_velocity = Vector3(0, 0, 0)

			::label_3_3::

			local smart_targeting_optimized = EngineOptimized.smart_targeting_optimized(_get_player_camera, var_3_43, right, var_3_44, effective_max_range, num_6, max_range, num_3, num, num_2, smart_targeting_width, smart_targeting_outer_width, smart_targeting_height_multiplier, (speed or 0) * 0.01, drop_multiplier, current_velocity, _gui)
			local var_3_50 = var_3_36[var_3_39]

			var_3_50 = var_3_50 or 0.1

			local num_7 = var_3_42 * smart_targeting_optimized * var_3_50

			if num_4 < num_7 then
				num_4 = num_7
				var_3_33 = var_3_39
				num_5 = smart_targeting_optimized
			end

			if num_7 > 0 then
				var_3_35[var_3_39] = min(var_3_50 + arg_3_3 * 2, 1)
			end
		until true
	end

	table.clear(var_3_36)

	self.use_score_modifiers_1 = not self.use_score_modifiers_1

	local var_3_52

	if not var_3_33 then
		local get_target_visibility_and_aim_position, var_3_54 = self:get_target_visibility_and_aim_position(var_3_33, current_position, var_3_21)

		var_3_52 = var_3_54

		if not get_target_visibility_and_aim_position then
			var_3_33 = nil
			num_5 = nil
			var_3_52 = nil
		end
	end

	local targeting_data = self.targeting_data

	targeting_data.unit = var_3_33
	targeting_data.aim_score = num_5

	if not var_3_52 then
		targeting_data.target_position = var_3_52
	end

	targeting_data.targets_within_range = flag_4
end

PlayerUnitSmartTargetingExtension.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	if not flag_4 then
		self:update_opt2(arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)

		return
	end

	if not flag_3 then
		return
	end

	table.clear(self.targeting_data)

	local node = Unit.node
	local world_position = Unit.world_position
	local world_to_screen = Camera.world_to_screen
	local get_data = Unit.get_data
	local right = Quaternion.right
	local forward = Quaternion.forward
	local length = Vector3.length
	local extension = ScriptUnit.extension
	local flat = Vector3.flat
	local dot = Vector3.dot
	local normalize = Vector3.normalize
	local res_w = RESOLUTION_LOOKUP.res_w
	local res_h = RESOLUTION_LOOKUP.res_h
	local num = res_w / 2
	local num_2 = res_h / 2
	local input_extension = self.input_extension
	local first_person_extension = self.first_person_extension
	local inventory_extension = self.inventory_extension
	local _get_player_camera = self:_get_player_camera()
	local current_position = first_person_extension:current_position()
	local current_rotation = first_person_extension:current_rotation()
	local var_4_21 = forward(current_rotation)
	local var_4_22
	local equipment = inventory_extension:equipment()
	local right_hand_wielded_unit = equipment.right_hand_wielded_unit

	right_hand_wielded_unit = right_hand_wielded_unit or equipment.left_hand_wielded_unit

	if not Unit.alive(right_hand_wielded_unit) then
		local extension_2 = ScriptUnit.extension(right_hand_wielded_unit, "weapon_system")

		if not extension_2:has_current_action() then
			var_4_22 = extension_2:get_current_action_settings()
		end
	end

	local var_4_26

	if not var_4_22 and not var_4_22.aim_assist_settings then
		var_4_26 = var_4_22.aim_assist_settings
	else
		var_4_26 = not weapon_template and weapon_template.aim_assist_settings
	end

	local get_wielded_slot_item_template = inventory_extension:get_wielded_slot_item_template()
	local get_loaded_projectile_settings = inventory_extension:get_loaded_projectile_settings()
	local is_device_active = Managers.input:is_device_active("gamepad")
	local flag_2 = not Application.user_setting("gamepad_auto_aim_enabled")

	if not var_4_26 and not is_device_active and not flag_2 then
		return
	end

	local max_range = var_4_26.max_range
	local effective_max_range = var_4_26.effective_max_range
	local broadphase = Managers.state.entity:system("ai_system").broadphase

	table.clear(tbl)

	local query = Broadphase.query(broadphase, current_position, max_range, tbl, self._target_broadphase_categories)
	local num_3 = 0
	local var_4_36
	local num_4 = 0
	local var_4_38
	local var_4_39

	if not self.use_score_modifiers_1 then
		var_4_38 = self.score_modifiers_1
		var_4_39 = self.score_modifiers_2
	else
		var_4_38 = self.score_modifiers_2
		var_4_39 = self.score_modifiers_1
	end

	local flag_5 = false

	for i = 1, query do
		repeat
			local var_4_41 = tbl[i]

			if not HEALTH_ALIVE[var_4_41] then
				break
			end

			local var_4_42 = get_data(var_4_41, "breed")
			local smart_targeting_width = var_4_42.smart_targeting_width

			if not (var_4_42.no_autoaim or smart_targeting_width) then
				break
			end

			flag_5 = true

			local var_4_44 = var_4_26.breed_scalars[var_4_42.name]

			var_4_44 = var_4_44 or 1

			if var_4_44 == 0 then
				break
			end

			local var_4_45 = node(var_4_41, "j_hips")
			local var_4_46 = world_position(var_4_41, var_4_45)
			local num_5 = var_4_46 - current_position

			if dot(var_4_21, normalize(num_5)) < 0.5 then
				break
			end

			local num_6 = 1
			local num_7 = 0.8
			local var_4_50 = length(num_5)

			if var_4_50 < 1.5 then
				break
			elseif var_4_50 <= effective_max_range then
				num_6 = (1 - var_4_50 / effective_max_range) * (1 - num_7) + num_7
			else
				num_6 = (1 - (var_4_50 - effective_max_range) / (max_range - effective_max_range)) * num_7
			end

			local smart_targeting_outer_width = var_4_42.smart_targeting_outer_width

			smart_targeting_outer_width = smart_targeting_outer_width or smart_targeting_width * 2

			local smart_targeting_height_multiplier = var_4_42.smart_targeting_height_multiplier

			smart_targeting_height_multiplier = smart_targeting_height_multiplier or 1

			local var_4_53 = extension(var_4_41, "locomotion_system")
			local flag_6 = not get_loaded_projectile_settings and get_loaded_projectile_settings.speed
			local zero = Vector3.zero()

			if not flag_6 then
				local current_velocity

				if not var_4_53 then
					current_velocity = var_4_53:current_velocity()

					if not current_velocity then
						-- Nothing
					end
				end

				current_velocity = Vector3(0, 0, 0)

				::label_4_0::

				zero = flat(current_velocity) * (var_4_50 / (flag_6 * 0.01))

				local z = zero.z
				local drop_multiplier = get_loaded_projectile_settings.drop_multiplier

				drop_multiplier = drop_multiplier or 0
				zero.z = z + var_4_50 * drop_multiplier
			end

			local num_8 = var_4_46 + right(current_rotation) * smart_targeting_width + zero
			local num_9 = var_4_46 + right(current_rotation) * smart_targeting_outer_width + zero
			local var_4_61 = world_to_screen(_get_player_camera, var_4_46 + zero)
			local var_4_62 = world_to_screen(_get_player_camera, num_8)
			local var_4_63 = world_to_screen(_get_player_camera, num_9)
			local num_10 = 8 * (res_w / 1280)
			local max = math.max(length(var_4_62 - var_4_61), num_10)
			local max_2 = math.max(length(var_4_63 - var_4_61), num_10 * (smart_targeting_outer_width / smart_targeting_width))
			local num_11 = max * smart_targeting_height_multiplier
			local abs = math.abs(max_2 - max)
			local num_12 = var_4_61.x - max
			local num_13 = var_4_61.x + max
			local num_14 = var_4_61.y - num_11
			local num_15 = var_4_61.y + num_11
			local num_16 = num_12 - abs
			local num_17 = num_13 + abs
			local num_18 = num_14 - abs
			local num_19 = num_15 + abs

			if not flag then
				Gui.rect(self._gui, Vector3(num_12, num_14, 800), Vector2(max * 2, num_11 * 2), Color(90, 0, 200, 200))
				Gui.rect(self._gui, Vector3(num_16, num_18, 800), Vector2(num_17 - num_16, num_19 - num_18), Color(90, 200, 200, 0))
			end

			local num_20 = 0
			local num_21 = 0

			if not (not (num_16 < num) or not (num < num_17) or not (num_18 < num_2) or not (num_2 < num_19)) then
				if num <= var_4_61.x then
					num_20 = math.min((num - num_16) / abs, 1)
				else
					num_20 = math.min((num_17 - num) / abs, 1)
				end

				if num_2 <= var_4_61.y then
					num_21 = math.min((num_2 - num_18) / abs, 1)
				else
					num_21 = math.min((num_19 - num_2) / abs, 1)
				end
			end

			local var_4_79 = var_4_39[var_4_41]

			var_4_79 = var_4_79 or 0.1

			local num_22 = num_20 * num_21
			local num_23 = var_4_44 * num_22 * num_6 * var_4_79

			if num_3 < num_23 then
				num_3 = num_23
				var_4_36 = var_4_41
				num_4 = num_22
			end

			if num_23 > 0 then
				var_4_38[var_4_41] = math.min(var_4_79 + arg_4_3 * 2, 1)
			end
		until true
	end

	table.clear(var_4_39)

	self.use_score_modifiers_1 = not self.use_score_modifiers_1

	local var_4_82

	if not var_4_36 then
		local get_target_visibility_and_aim_position, var_4_84 = self:get_target_visibility_and_aim_position(var_4_36, current_position, var_4_26)

		var_4_82 = var_4_84

		if not get_target_visibility_and_aim_position then
			var_4_36 = nil
			num_4 = nil
			var_4_82 = nil
		end
	end

	local targeting_data = self.targeting_data

	targeting_data.unit = var_4_36
	targeting_data.aim_score = num_4
	targeting_data.target_position = var_4_82
	targeting_data.targets_within_range = flag_5
end

PlayerUnitSmartTargetingExtension._get_player_camera = function (self)
	-- function 5
	local viewport_name = self.player.viewport_name
	local viewport = ScriptWorld.viewport(self.world, viewport_name)

	return (ScriptViewport.camera(viewport))
end

PlayerUnitSmartTargetingExtension.get_target_visibility_and_aim_position = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local target_node = arg_6_3.target_node

	target_node = target_node or "j_spine1"

	local node = Unit.node(arg_6_1, target_node)
	local world_position = Unit.world_position(arg_6_1, node)
	local node_2 = Unit.node(arg_6_1, "j_hips")
	local world_position_2 = Unit.world_position(arg_6_1, node_2)
	local normalize = Vector3.normalize(world_position - arg_6_2)
	local length = Vector3.length(world_position - arg_6_2)
	local normalize_2 = Vector3.normalize(world_position_2 - arg_6_2)
	local length_2 = Vector3.length(world_position_2 - arg_6_2)
	local physics_world = World.physics_world(self.world)
	local flag = not PhysicsWorld.immediate_raycast(physics_world, arg_6_2, normalize, length, "closest", "collision_filter", "filter_ray_aim_assist")
	local var_6_11 = world_position

	if not flag then
		flag = not PhysicsWorld.immediate_raycast(physics_world, arg_6_2, normalize_2, length_2, "closest", "collision_filter", "filter_ray_aim_assist")
		var_6_11 = world_position_2
	end

	return flag, var_6_11
end

PlayerUnitSmartTargetingExtension.get_targeting_data = function (self)
	-- function 7
	return self.targeting_data
end
