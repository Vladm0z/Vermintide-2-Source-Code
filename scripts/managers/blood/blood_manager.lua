-- chunkname: @scripts/managers/blood/blood_manager.lua

require("scripts/managers/blood/blood_settings")

BloodManager = class(BloodManager)

local var_0_0 = 64
local var_0_1 = 15

BloodManager.init = function (arg_1_0, arg_1_1)
	arg_1_0._world = arg_1_1
	arg_1_0._weapon_blood = {}
	arg_1_0._blood_effect_data = {}
	arg_1_0._blood_active = true

	arg_1_0:_create_blood_ball_buffer()

	local var_1_0 = 5

	arg_1_0._blood_system = EngineOptimizedExtensions.blood_init_system(arg_1_0._blood_system, arg_1_0._world, "blood_ball", var_1_0)

	arg_1_0:_init_settings()
end

BloodManager.destroy = function (arg_2_0)
	arg_2_0:clear_weapon_blood()
	EngineOptimizedExtensions.blood_destroy_system(arg_2_0._blood_system)
end

BloodManager.update = function (arg_3_0, arg_3_1, arg_3_2)
	if arg_3_0._blood_active then
		local var_3_0 = World.time(arg_3_0._world)

		arg_3_0:_update_weapon_blood(arg_3_1, var_3_0)
		arg_3_0:_update_blood_ball_buffer()
	end

	arg_3_0:_update_blood_effects()
	EngineOptimizedExtensions.blood_update(arg_3_0._blood_system)
end

BloodManager.update_blood_enabled = function (arg_4_0, arg_4_1)
	if not arg_4_1 and arg_4_0._blood_active then
		arg_4_0:clear_weapon_blood()
		arg_4_0:clear_blood_decals()
	end

	arg_4_0._blood_active = arg_4_1
	BloodSettings.enemy_blood.enabled = arg_4_1
	BloodSettings.blood_decals.enabled = arg_4_1
	BloodSettings.weapon_blood.enabled = arg_4_1
	BloodSettings.hit_effects.enabled = arg_4_1
end

BloodManager.get_blood_enabled = function (arg_5_0)
	return arg_5_0._blood_active
end

BloodManager.update_num_blood_decals = function (arg_6_0, arg_6_1)
	BloodSettings.blood_decals.num_decals = arg_6_1
end

BloodManager.update_screen_blood_enabled = function (arg_7_0, arg_7_1)
	BloodSettings.screen_space.enabled = arg_7_1
end

BloodManager.update_dismemberment_enabled = function (arg_8_0, arg_8_1)
	BloodSettings.dismemberment.enabled = arg_8_1
end

BloodManager.update_ragdoll_enabled = function (arg_9_0, arg_9_1)
	BloodSettings.ragdoll_push.enabled = arg_9_1
end

BloodManager._init_settings = function (arg_10_0)
	local var_10_0 = Application.user_setting("blood_enabled") or var_10_0 == nil

	arg_10_0:update_blood_enabled(var_10_0)

	local var_10_1 = Application.user_setting("num_blood_decals") or BloodSettings.blood_decals.num_decals

	arg_10_0:update_num_blood_decals(var_10_1)

	local var_10_2 = Application.user_setting("screen_blood_enabled") or var_10_2 == nil

	arg_10_0:update_screen_blood_enabled(var_10_2)

	local var_10_3 = Application.user_setting("dismemberment_enabled") or var_10_3 == nil

	arg_10_0:update_dismemberment_enabled(var_10_3)

	local var_10_4 = Application.user_setting("ragdoll_enabled") or var_10_4 == nil

	arg_10_0:update_ragdoll_enabled(var_10_4)
end

BloodManager._update_weapon_blood = function (arg_11_0, arg_11_1, arg_11_2)
	for iter_11_0, iter_11_1 in pairs(arg_11_0._weapon_blood) do
		for iter_11_2, iter_11_3 in pairs(iter_11_1) do
			iter_11_1[iter_11_2] = math.clamp(iter_11_3 - BloodSettings.weapon_blood.dissolve_rate * arg_11_1, 0, BloodSettings.weapon_blood.max_value)

			arg_11_0:_set_weapon_blood_intensity(iter_11_0, iter_11_2, iter_11_1[iter_11_2])
		end
	end
end

BloodManager.clear_blood_decals = function (arg_12_0)
	Managers.state.decal:clear_all_of_type("blood_decals")
end

BloodManager.clear_unit_decals = function (arg_13_0, arg_13_1)
	Unit.set_vector4_for_materials(arg_13_1, "hit_position", Color(0, 0, 0, 0))
end

BloodManager._update_blood_effects = function (arg_14_0)
	for iter_14_0, iter_14_1 in pairs(arg_14_0._blood_effect_data) do
		if not HEALTH_ALIVE[iter_14_0] and not iter_14_1.done then
			for iter_14_2, iter_14_3 in ipairs(iter_14_1) do
				if iter_14_3.effect_id then
					World.destroy_particles(arg_14_0._world, iter_14_3.effect_id)
				end
			end

			arg_14_0._blood_effect_data[iter_14_0].done = true
		end
	end
end

BloodManager._set_weapon_blood_intensity = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	if Unit.alive(arg_15_2) then
		Unit.set_scalar_for_materials(arg_15_2, "blood_intensity", arg_15_3)
	else
		arg_15_0._weapon_blood[arg_15_1][arg_15_2] = nil
	end
end

BloodManager.clear_weapon_blood = function (arg_16_0, arg_16_1, arg_16_2)
	if arg_16_1 and arg_16_0._weapon_blood[arg_16_1] then
		local var_16_0 = arg_16_0._weapon_blood[arg_16_1]

		if arg_16_2 and var_16_0[arg_16_2] then
			arg_16_0:_set_weapon_blood_intensity(arg_16_1, arg_16_2, 0)

			arg_16_0._weapon_blood[arg_16_1][arg_16_2] = nil
		elseif not arg_16_2 then
			for iter_16_0, iter_16_1 in pairs(var_16_0) do
				arg_16_0:_set_weapon_blood_intensity(arg_16_1, iter_16_0, 0)
			end

			arg_16_0._weapon_blood[arg_16_1] = nil
		end
	else
		for iter_16_2, iter_16_3 in pairs(arg_16_0._weapon_blood) do
			for iter_16_4, iter_16_5 in pairs(iter_16_3) do
				arg_16_0._weapon_blood[iter_16_2][iter_16_4] = nil

				arg_16_0:_set_weapon_blood_intensity(iter_16_2, iter_16_4, 0)
			end
		end

		arg_16_0._weapon_blood = {}
	end
end

BloodManager._update_blood_ball_buffer = function (arg_17_0)
	local var_17_0 = arg_17_0._blood_ball_ring_buffer
	local var_17_1 = var_17_0.size

	if var_17_1 == 0 then
		return
	end

	local var_17_2 = var_17_0.buffer
	local var_17_3 = var_17_0.read_index
	local var_17_4 = var_17_0.max_size
	local var_17_5 = math.min(var_0_1, var_17_1)

	for iter_17_0 = 1, var_17_5 do
		local var_17_6 = var_17_2[var_17_3]

		arg_17_0:_spawn_blood_ball(var_17_6)

		var_17_3 = var_17_3 % var_17_4 + 1
		var_17_1 = var_17_1 - 1
	end

	var_17_0.size = var_17_1
	var_17_0.read_index = var_17_3
end

BloodManager._create_blood_ball_buffer = function (arg_18_0)
	local var_18_0 = var_0_0

	arg_18_0._blood_ball_ring_buffer = {
		write_index = 1,
		read_index = 1,
		size = 0,
		buffer = Script.new_array(var_18_0),
		max_size = var_18_0
	}

	for iter_18_0 = 1, var_18_0 do
		arg_18_0._blood_ball_ring_buffer.buffer[iter_18_0] = {
			velocity = 0,
			position = Vector3Box(),
			direction = Vector3Box()
		}
	end
end

BloodManager._spawn_blood_ball = function (arg_19_0, arg_19_1)
	local var_19_0 = arg_19_1.position:unbox()
	local var_19_1 = arg_19_1.direction:unbox()
	local var_19_2 = Quaternion.look(var_19_1, Vector3.up())
	local var_19_3 = arg_19_1.velocity

	EngineOptimizedExtensions.blood_spawn_blood_ball(arg_19_0._blood_system, "units/decals/blood_ball", var_19_0, var_19_2, var_19_1, var_19_3)
end

BloodManager.despawn_blood_ball = function (arg_20_0, arg_20_1)
	EngineOptimizedExtensions.blood_despawn_blood_ball(arg_20_0._blood_system, arg_20_1)
end

BloodManager._add_blood_ball_data_to_buffer = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	local var_21_0 = arg_21_0._blood_ball_ring_buffer
	local var_21_1 = var_21_0.buffer
	local var_21_2 = var_21_0.read_index
	local var_21_3 = var_21_0.write_index
	local var_21_4 = var_21_0.size
	local var_21_5 = var_21_0.max_size

	if var_21_5 < var_21_4 + 1 then
		local var_21_6 = var_21_1[var_21_2]

		arg_21_0:_spawn_blood_ball(var_21_6)

		var_21_0.size = var_21_4 - 1
		var_21_0.read_index = var_21_2 % var_21_5 + 1
	end

	local var_21_7 = BloodSettings.blood_ball.damage_type_velocities[arg_21_3]
	local var_21_8 = BloodSettings.blood_ball.damage_type_velocities.default
	local var_21_9 = var_21_1[var_21_3]

	var_21_9.position:store(arg_21_1)
	var_21_9.direction:store(arg_21_2)

	var_21_9.velocity = var_21_7 or var_21_8
	var_21_0.size = var_21_4 + 1
	var_21_0.write_index = var_21_3 % var_21_5 + 1
end

BloodManager.add_blood_ball = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	if BloodSettings.blood_decals.enabled then
		local var_22_0 = Unit.get_data(arg_22_4, "breed")

		if BloodSettings.blood_decals.num_decals > 0 and Vector3.is_valid(arg_22_1) and not var_22_0.no_blood then
			arg_22_0:_add_blood_ball_data_to_buffer(arg_22_1, arg_22_2, arg_22_3)
		end

		local var_22_1 = ScriptUnit.extension(arg_22_4, "health_system")

		if var_22_0.blood_effect_name then
			arg_22_0:_spawn_effects(arg_22_4, var_22_0, var_22_1)
		end

		if var_22_0.blood_intensity then
			arg_22_0:_update_blood_intensity(arg_22_4, var_22_0, var_22_1)
		end
	end
end

BloodManager._get_blood_effect_data = function (arg_23_0, arg_23_1, arg_23_2)
	if not arg_23_0._blood_effect_data[arg_23_1] then
		arg_23_0._blood_effect_data[arg_23_1] = table.clone(arg_23_2)
	end

	return arg_23_0._blood_effect_data[arg_23_1]
end

BloodManager._spawn_effects = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	local var_24_0 = arg_24_2.blood_effect_name
	local var_24_1 = arg_24_2.blood_effect_nodes
	local var_24_2 = arg_24_0:_get_blood_effect_data(arg_24_1, var_24_1)

	if var_24_2.done then
		return
	end

	local var_24_3 = 1 - arg_24_3:current_health_percent()
	local var_24_4 = 1 / (#var_24_2 + 1)
	local var_24_5 = var_24_4

	for iter_24_0, iter_24_1 in ipairs(var_24_2) do
		if var_24_5 < var_24_3 then
			if not iter_24_1.triggered then
				local var_24_6 = World.create_particles(arg_24_0._world, var_24_0, Vector3(0, 0, 0))

				var_24_2[iter_24_0].effect_id = var_24_6

				local var_24_7 = Unit.node(arg_24_1, iter_24_1.node)
				local var_24_8 = Matrix4x4.from_quaternion(Unit.local_rotation(arg_24_1, var_24_7))

				World.link_particles(arg_24_0._world, var_24_6, arg_24_1, var_24_7, var_24_8, "destroy")

				var_24_2[iter_24_0].triggered = true
			end
		else
			break
		end

		var_24_5 = var_24_5 + var_24_4
	end
end

BloodManager._update_blood_intensity = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	local var_25_0 = arg_25_2.blood_intensity
	local var_25_1 = Unit.num_meshes(arg_25_1)
	local var_25_2 = 1 - arg_25_3:current_health_percent()

	for iter_25_0 = 0, var_25_1 - 1 do
		local var_25_3 = Unit.mesh(arg_25_1, iter_25_0)

		for iter_25_1, iter_25_2 in pairs(var_25_0) do
			if Mesh.has_material(var_25_3, iter_25_1) then
				local var_25_4 = Mesh.material(var_25_3, iter_25_1)

				Material.set_scalar(var_25_4, iter_25_2, var_25_2)
			end
		end
	end
end

BloodManager.add_weapon_blood = function (arg_26_0, arg_26_1, arg_26_2)
	if BloodSettings.weapon_blood.enabled and arg_26_0:_is_player(arg_26_1) and arg_26_0:_is_melee_weapon(arg_26_1) then
		local var_26_0 = ScriptUnit.extension(arg_26_1, "inventory_system"):equipment()
		local var_26_1 = var_26_0.right_hand_wielded_unit
		local var_26_2 = var_26_0.right_hand_wielded_unit_3p
		local var_26_3 = var_26_0.left_hand_wielded_unit
		local var_26_4 = var_26_0.left_hand_wielded_unit_3p
		local var_26_5 = BloodSettings.weapon_blood[arg_26_2] or BloodSettings.weapon_blood.default

		arg_26_0._weapon_blood[arg_26_1] = arg_26_0._weapon_blood[arg_26_1] or {}

		if var_26_1 then
			arg_26_0._weapon_blood[arg_26_1][var_26_1] = math.max((arg_26_0._weapon_blood[arg_26_1][var_26_1] or 0) + var_26_5, BloodSettings.weapon_blood.starting_value)
		end

		if var_26_2 then
			arg_26_0._weapon_blood[arg_26_1][var_26_2] = math.max((arg_26_0._weapon_blood[arg_26_1][var_26_2] or 0) + var_26_5, BloodSettings.weapon_blood.starting_value)
		end

		if var_26_3 then
			arg_26_0._weapon_blood[arg_26_1][var_26_3] = math.max((arg_26_0._weapon_blood[arg_26_1][var_26_3] or 0) + var_26_5, BloodSettings.weapon_blood.starting_value)
		end

		if var_26_4 then
			arg_26_0._weapon_blood[arg_26_1][var_26_4] = math.max((arg_26_0._weapon_blood[arg_26_1][var_26_2] or 0) + var_26_5, BloodSettings.weapon_blood.starting_value)
		end
	end
end

BloodManager.add_enemy_blood = function (arg_27_0, arg_27_1, arg_27_2)
	if BloodSettings.enemy_blood.enabled and HEALTH_ALIVE[arg_27_2] then
		local var_27_0 = Unit.local_position(arg_27_2, 0)
		local var_27_1, var_27_2 = Unit.box(arg_27_2)
		local var_27_3 = var_27_2[3] * 0.5
		local var_27_4 = math.max(var_27_2[1], var_27_2[2]) * 0.5
		local var_27_5 = var_27_0 + Vector3(0, 0, var_27_3)
		local var_27_6 = var_27_5 + Vector3.normalize(arg_27_1 - var_27_5) * var_27_4
		local var_27_7 = Unit.local_pose(arg_27_2, 0)
		local var_27_8 = Matrix4x4.inverse(var_27_7)
		local var_27_9 = Vector3.normalize(arg_27_1 - var_27_5)
		local var_27_10 = Vector3.cross(var_27_9, Vector3.up())
		local var_27_11 = Matrix4x4.transform(var_27_8, var_27_6)
		local var_27_12 = Vector3.normalize(Matrix4x4.transform_without_translation(var_27_8, var_27_9))
		local var_27_13 = Vector3.normalize(Matrix4x4.transform_without_translation(var_27_8, var_27_10))
		local var_27_14 = Color(var_27_11[1], var_27_11[2], var_27_11[3], 1)
		local var_27_15 = Color(var_27_12[1], var_27_12[2], var_27_12[3], 0)
		local var_27_16 = Color(var_27_13[1], var_27_13[2], var_27_13[3], 0)

		Unit.set_vector4_for_materials(arg_27_2, "hit_position", var_27_14)
		Unit.set_vector4_for_materials(arg_27_2, "hit_normal", var_27_15)
		Unit.set_vector4_for_materials(arg_27_2, "hit_tangent", var_27_16)
	end
end

BloodManager.play_screen_space_blood = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)
	if BloodSettings.screen_space.enabled then
		World.create_particles(arg_28_0._world, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)
	end
end

BloodManager._is_melee_weapon = function (arg_29_0, arg_29_1)
	local var_29_0 = ScriptUnit.has_extension(arg_29_1, "inventory_system")

	if not var_29_0 then
		return false
	end

	local var_29_1 = var_29_0:equipment()

	if not var_29_1.wielded then
		return false
	end

	return var_29_1.wielded.slot_type == "melee"
end

BloodManager._is_player = function (arg_30_0, arg_30_1)
	local var_30_0 = Managers.player:players()

	for iter_30_0, iter_30_1 in pairs(var_30_0) do
		if iter_30_1.player_unit == arg_30_1 then
			return iter_30_1
		end
	end

	return false
end
