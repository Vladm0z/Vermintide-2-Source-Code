-- chunkname: @scripts/settings/dlcs/woods/action_career_we_thornsister_wall.lua

ActionCareerWEThornsisterWall = class(ActionCareerWEThornsisterWall, ActionBase)

local var_0_0 = "thornsister_thorn_wall_unit"
local var_0_1 = 0.1
local var_0_2 = 0.05
local var_0_3 = 0.5

function ActionCareerWEThornsisterWall.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionCareerWEThornsisterWall.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0.career_extension = ScriptUnit.extension(arg_1_4, "career_system")
	arg_1_0.inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	arg_1_0.talent_extension = ScriptUnit.extension(arg_1_4, "talent_system")
	arg_1_0._wall_index = 0
end

function ActionCareerWEThornsisterWall.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	arg_2_5 = arg_2_5 or {}

	ActionCareerWEThornsisterWall.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)

	local var_2_0 = arg_2_3
	local var_2_1 = var_2_0 and var_2_0.num_segments or 0

	if var_2_1 > 0 then
		arg_2_0:_play_vo()

		local var_2_2 = var_2_0.position:unbox()
		local var_2_3 = var_2_0.rotation:unbox()
		local var_2_4 = var_2_0.segments
		local var_2_5 = "we_thornsister_career_skill_wall_explosion"
		local var_2_6 = 1
		local var_2_7 = arg_2_0.career_extension
		local var_2_8 = var_2_7:get_career_power_level()
		local var_2_9 = Managers.state.entity:system("area_damage_system")

		if arg_2_0.talent_extension:has_talent("kerillian_thorn_sister_debuff_wall") then
			if arg_2_0.talent_extension:has_talent("kerillian_thorn_sister_double_poison") then
				var_2_5 = "we_thornsister_career_skill_explosive_wall_explosion_improved"
			else
				var_2_5 = "we_thornsister_career_skill_explosive_wall_explosion"
			end
		elseif arg_2_0.talent_extension:has_talent("kerillian_thorn_sister_wall_push") then
			var_2_5 = nil
		end

		if var_2_5 then
			arg_2_0:_spawn_wall(var_2_1, var_2_4, var_2_3)
			var_2_9:create_explosion(arg_2_0.owner_unit, var_2_2, var_2_3, var_2_5, var_2_6, "career_ability", var_2_8, false)
		else
			local var_2_10 = "thornsister_thorn_wall_push"
			local var_2_11 = NetworkLookup.damage_wave_templates[var_2_10]
			local var_2_12 = Managers.state.network
			local var_2_13 = var_2_12:unit_game_object_id(arg_2_0.owner_unit)
			local var_2_14 = Quaternion.forward(var_2_3)
			local var_2_15 = Quaternion.right(var_2_3)
			local var_2_16 = {}

			for iter_2_0 = 1, var_2_1 do
				var_2_16[iter_2_0] = var_2_4[iter_2_0]:unbox() + var_2_14 * (math.random() * var_0_1 * 2 - var_0_1) + var_2_15 * (math.random() * var_0_2 * 2 - var_0_2)
			end

			local var_2_17 = arg_2_0:_get_next_wall_index()

			var_2_12.network_transmit:send_rpc_server("rpc_create_thornsister_push_wave", var_2_13, POSITION_LOOKUP[arg_2_0.owner_unit], var_2_2, var_2_11, var_2_8, var_2_16, var_2_17)
		end

		var_2_7:start_activated_ability_cooldown()
	end
end

function ActionCareerWEThornsisterWall.client_owner_post_update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	return
end

function ActionCareerWEThornsisterWall.finish(arg_4_0, arg_4_1)
	arg_4_0.inventory_extension:wield_previous_non_level_slot()
end

function ActionCareerWEThornsisterWall._play_vo(arg_5_0)
	local var_5_0 = arg_5_0.owner_unit
	local var_5_1 = ScriptUnit.extension_input(var_5_0, "dialogue_system")
	local var_5_2 = FrameTable.alloc_table()

	var_5_1:trigger_networked_dialogue_event("activate_ability", var_5_2)
end

function ActionCareerWEThornsisterWall._get_next_wall_index(arg_6_0)
	local var_6_0 = arg_6_0._wall_index % 16 + 1

	arg_6_0._wall_index = var_6_0

	return var_6_0
end

function ActionCareerWEThornsisterWall._spawn_wall(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = arg_7_0:_get_next_wall_index()
	local var_7_1 = arg_7_0.owner_unit
	local var_7_2 = Quaternion.forward(arg_7_3)
	local var_7_3 = Quaternion.right(arg_7_3)

	for iter_7_0 = 1, arg_7_1 do
		local var_7_4 = arg_7_2[iter_7_0]:unbox()
		local var_7_5 = arg_7_3
		local var_7_6 = var_7_4 + var_7_2 * (math.random() * var_0_1 * 2 - var_0_1) + var_7_3 * (math.random() * var_0_2 * 2 - var_0_2)

		Managers.state.unit_spawner:request_spawn_template_unit(var_0_0, var_7_6, var_7_5, var_7_1, var_7_0, iter_7_0)
	end
end
