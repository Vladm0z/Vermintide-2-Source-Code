-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_place_standard_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTPlaceStandardAction = class(BTPlaceStandardAction, BTNode)

BTPlaceStandardAction.init = function (arg_1_0, ...)
	-- function 1
	BTPlaceStandardAction.super.init(arg_1_0, ...)
end

BTPlaceStandardAction.name = "BTPlaceStandardAction"

local function fn(self)
	-- function 2
	if type(self) == "table" then
		return self[Math.random(1, #self)]
	else
		return self
	end
end

BTPlaceStandardAction.enter = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	arg_3_2.action = self._tree_node.action_data
	arg_3_2.active_node = BTPlaceStandardAction

	arg_3_2.navigation_extension:set_enabled(false)
	arg_3_2.locomotion_extension:set_wanted_velocity(Vector3(0, 0, 0))

	arg_3_2.attacking_target = arg_3_2.target_unit
	arg_3_2.anim_cb_placed_standard = nil
	arg_3_2.anim_cb_place_standard = nil
	arg_3_2.attack_aborted = nil
end

BTPlaceStandardAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local get_default_breed_move_speed = AiUtils.get_default_breed_move_speed(arg_4_1, arg_4_2)
	local navigation_extension = arg_4_2.navigation_extension

	navigation_extension:set_enabled(true)
	navigation_extension:set_max_speed(get_default_breed_move_speed)

	arg_4_2.active_node = nil
	arg_4_2.action = nil
	arg_4_2.attacking_target = nil
	arg_4_2.attack_aborted = nil

	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_4_1, true)

	if not arg_4_2.anim_cb_place_standard then
		arg_4_2.has_placed_standard = true
		arg_4_2.switching_weapons = 2
	end

	if arg_4_2.move_state == "idle" or not HEALTH_ALIVE[arg_4_1] then
		arg_4_2.move_state = "idle"
	end

	arg_4_2.anim_cb_placed_standard = nil
	arg_4_2.anim_cb_place_standard = nil
end

BTPlaceStandardAction.run = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	if arg_5_2.anim_cb_placed_standard or not arg_5_2.attack_aborted then
		return "done"
	end

	if arg_5_2.move_state ~= "attacking" then
		Managers.state.network:anim_event(arg_5_1, fn(arg_5_2.action.place_standard_animation))

		arg_5_2.move_state = "attacking"
	end

	return "running"
end

BTPlaceStandardAction.anim_cb_place_standard = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	if not Managers.state.network:game() then
		local var_6_0 = POSITION_LOOKUP[arg_6_1]
		local num = var_6_0 + Quaternion.forward(Unit.local_rotation(arg_6_1, 0))
		local var_6_2
		local nav_world = arg_6_2.nav_world
		local num_2 = 1
		local num_3 = 1
		local triangle_from_position, var_6_7 = GwNavQueries.triangle_from_position(nav_world, num, num_2, num_3)

		if not triangle_from_position then
			var_6_2 = Vector3.copy(num)
			var_6_2.z = var_6_7
		else
			local num_4 = 1
			local num_5 = 0.05

			var_6_2 = GwNavQueries.inside_position_from_outside_position(nav_world, num, num_2, num_3, num_4, num_5)
		end

		if not var_6_2 then
			local action = arg_6_2.action
			local tbl = {
				health_system = {
					health = action.standard_health
				},
				death_system = {
					death_reaction_template = "standard"
				},
				ai_supplementary_system = {
					standard_template_name = action.standard_template_name,
					standard_bearer_unit = arg_6_1
				},
				ping_system = {
					always_pingable = true
				}
			}
			local str = "units/weapons/enemy/wpn_bm_standard_01/wpn_bm_standard_01_placed"
			local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(str, "standard_unit", tbl, var_6_2)

			arg_6_2.standard_unit = spawn_network_unit

			local world = arg_6_2.world
			local local_position = Unit.local_position(spawn_network_unit, 0)
			local get_template = ExplosionUtils.get_template("standard_bearer_explosion")
			local name = arg_6_2.breed.name
			local broadphase = arg_6_2.group_blackboard.broadphase
			local radius = get_template.explosion.radius
			local alloc_table = FrameTable.alloc_table()
			local alloc_table_2 = FrameTable.alloc_table()
			local query = Broadphase.query(broadphase, var_6_0, radius, alloc_table)

			for i = 1, query do
				local var_6_23 = alloc_table[i]

				if not HEALTH_ALIVE[var_6_23] then
					local var_6_24 = BLACKBOARDS[var_6_23]

					if var_6_24.breed.race == "beastmen" then
						var_6_24.standard_bearer_stagger = true
						alloc_table_2[#alloc_table_2 + 1] = var_6_24
					end
				end
			end

			DamageUtils.create_explosion(world, arg_6_2.target_unit, local_position, Quaternion.identity(), get_template, 1, name, true, false, arg_6_1, false, nil, arg_6_1)

			for j = 1, #alloc_table_2 do
				local var_6_25 = alloc_table_2[j]
			end

			local go_id = Managers.state.unit_storage:go_id(arg_6_1)
			local var_6_27 = NetworkLookup.explosion_templates[get_template.name]
			local var_6_28 = NetworkLookup.damage_sources[name]

			Managers.state.network.network_transmit:send_rpc_clients("rpc_create_explosion", go_id, false, local_position, Quaternion.identity(), var_6_27, 1, var_6_28, 0, false, go_id)
		end

		arg_6_2.anim_cb_place_standard = true

		if not arg_6_2.triggered_standard_chanting_sound then
			Managers.state.entity:system("audio_system"):play_audio_unit_event(arg_6_2.action.stop_chanting_sound_event, arg_6_1)

			arg_6_2.triggered_standard_chanting_sound = nil
		end

		Managers.state.entity:system("surrounding_aware_system"):add_system_event(arg_6_1, "has_planted_standard", DialogueSettings.special_proximity_distance_heard)
	end
end

BTPlaceStandardAction.anim_cb_placed_standard = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	arg_7_2.anim_cb_placed_standard = true
end
