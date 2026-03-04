-- chunkname: @scripts/unit_extensions/human/ai_player_unit/ai_husk_base_extension.lua

AiHuskBaseExtension = class(AiHuskBaseExtension)

function AiHuskBaseExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.is_husk = true
	arg_1_0.unit = arg_1_2
	arg_1_0.game = arg_1_3.game
	arg_1_0.go_id = arg_1_3.go_id

	local var_1_0 = Unit.get_data(arg_1_2, "breed")

	arg_1_0._breed = var_1_0

	if not var_1_0.hit_zones_lookup then
		DamageUtils.create_hit_zone_lookup(arg_1_2, var_1_0)
	end

	local var_1_1 = var_1_0.blackboard_init_data

	if var_1_1 and var_1_1.player_locomotion_constrain_radius ~= nil then
		arg_1_0.player_locomotion_constrain_radius = var_1_1.player_locomotion_constrain_radius or nil
	else
		arg_1_0.player_locomotion_constrain_radius = var_1_0.player_locomotion_constrain_radius or nil
	end

	local var_1_2 = var_1_0.run_on_husk_spawn

	if var_1_2 then
		var_1_2(arg_1_2)
	end

	if var_1_0.special_on_spawn_stinger then
		WwiseUtils.trigger_unit_event(arg_1_1.world, var_1_0.special_on_spawn_stinger, arg_1_2, 0)
	end

	arg_1_0._side_id = arg_1_3.side_id
	arg_1_0.attributes = nil
end

function AiHuskBaseExtension.extensions_ready(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = arg_2_0._side_id
	local var_2_1 = Managers.state.side

	var_2_1:add_unit_to_side(arg_2_2, var_2_0)

	local var_2_2 = ScriptUnit.has_extension(arg_2_2, "health_system")

	if var_2_2 then
		local var_2_3 = Managers.state.entity:system("ai_system").broadphase
		local var_2_4 = var_2_1:get_side(var_2_0)

		arg_2_0.broadphase_id = Broadphase.add(var_2_3, arg_2_2, Unit.local_position(arg_2_2, 0), 1, var_2_4.broadphase_category)
		arg_2_0.broadphase = var_2_3
		arg_2_0._health_extension = var_2_2
	end

	Unit.flow_event(arg_2_2, "lua_trigger_variation")

	local var_2_5 = LevelSettings[Managers.state.game_mode:level_key()].climate_type or "default"

	Unit.set_flow_variable(arg_2_2, "climate_type", var_2_5)
	Unit.flow_event(arg_2_2, "climate_type_set")
end

function AiHuskBaseExtension.freeze(arg_3_0)
	arg_3_0._side_id = nil
end

function AiHuskBaseExtension.unfreeze(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_2[7].side_id

	arg_4_0._side_id = var_4_0

	Managers.state.side:add_unit_to_side(arg_4_1, var_4_0)

	if arg_4_0.attributes then
		table.clear(arg_4_0.attributes)
	end

	local var_4_1 = arg_4_0._breed.run_on_husk_spawn

	if var_4_1 then
		var_4_1(arg_4_0.unit)
	end
end

function AiHuskBaseExtension.current_action_name(arg_5_0)
	local var_5_0 = arg_5_0.game
	local var_5_1 = arg_5_0.go_id

	return NetworkLookup.bt_action_names[GameSession.game_object_field(var_5_0, var_5_1, "bt_action_name")]
end

function AiHuskBaseExtension.breed(arg_6_0)
	return arg_6_0._breed
end

function AiHuskBaseExtension.update(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	if arg_7_0.broadphase_id and HEALTH_ALIVE[arg_7_1] then
		Broadphase.move(arg_7_0.broadphase, arg_7_0.broadphase_id, POSITION_LOOKUP[arg_7_1])
	end
end

function AiHuskBaseExtension.unit_removed_from_game(arg_8_0)
	Managers.state.side:remove_unit_from_side(arg_8_0.unit)

	arg_8_0._side_id = nil
end

function AiHuskBaseExtension.destroy(arg_9_0, arg_9_1, arg_9_2)
	return
end
