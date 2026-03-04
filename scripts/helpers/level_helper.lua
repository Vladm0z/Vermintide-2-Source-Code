-- chunkname: @scripts/helpers/level_helper.lua

LevelHelper = LevelHelper or {}
LevelHelper.INGAME_WORLD_NAME = "level_world"

LevelHelper.current_level_settings = function (arg_1_0)
	if Managers.state.game_mode then
		local var_1_0 = Managers.state.game_mode:level_key()

		return LevelSettings[var_1_0]
	end

	return nil
end

LevelHelper.current_level = function (arg_2_0, arg_2_1)
	local var_2_0 = arg_2_0:current_level_settings()

	return (ScriptWorld.level(arg_2_1, var_2_0.level_name))
end

LevelHelper.get_environment_variation_id = function (arg_3_0, arg_3_1)
	local var_3_0 = Managers.backend:get_title_data("environment_variations")

	if not var_3_0 then
		return arg_3_0:get_random_variation_id(arg_3_1)
	end

	local var_3_1 = cjson.decode(var_3_0)[arg_3_1]

	if not var_3_1 then
		return 0
	end

	local var_3_2 = var_3_1.type

	if var_3_2 == "random" then
		return arg_3_0:get_random_variation_id(arg_3_1)
	elseif var_3_2 == "specific" then
		local var_3_3 = LevelSettings[arg_3_1]
		local var_3_4 = var_3_3 and var_3_3.environment_variations

		if not var_3_4 or #var_3_4 < 1 then
			return 0
		end

		local var_3_5 = var_3_1.variations
		local var_3_6
		local var_3_7
		local var_3_8

		while #var_3_5 > 0 do
			local var_3_9 = math.random(1, #var_3_5)
			local var_3_10 = var_3_5[var_3_9]

			if var_3_10 == "default" then
				return 0
			end

			local var_3_11 = table.find(var_3_4, var_3_10)

			if var_3_11 then
				return var_3_11
			else
				table.remove(var_3_5, var_3_9)
			end
		end
	elseif var_3_2 == "default" then
		return 0
	end

	return 0
end

LevelHelper.get_random_variation_id = function (arg_4_0, arg_4_1)
	local var_4_0 = rawget(LevelSettings, arg_4_1)
	local var_4_1 = var_4_0 and var_4_0.environment_variations

	return var_4_1 and math.random(0, #var_4_1) or 0
end

LevelHelper.flow_event = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0:current_level_settings()
	local var_5_1 = ScriptWorld.level(arg_5_1, var_5_0.level_name)

	Level.trigger_event(var_5_1, arg_5_2)
end

LevelHelper.set_flow_parameter = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_0:current_level_settings()
	local var_6_1 = ScriptWorld.level(arg_6_1, var_6_0.level_name)

	Level.set_flow_variable(var_6_1, arg_6_2, arg_6_3)
end

LevelHelper.unit_index = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0:current_level(arg_7_1)

	return Level.unit_index(var_7_0, arg_7_2)
end

LevelHelper.unit_by_index = function (arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_0:current_level(arg_8_1)

	return Level.unit_by_index(var_8_0, arg_8_2)
end

LevelHelper.find_dialogue_unit = function (arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = LevelHelper:current_level(arg_9_1)
	local var_9_1 = Level.units(var_9_0)
	local var_9_2

	for iter_9_0, iter_9_1 in ipairs(var_9_1) do
		if Unit.has_data(iter_9_1, "dialogue_profile") and Unit.get_data(iter_9_1, "dialogue_profile") == arg_9_2 then
			var_9_2 = iter_9_1

			break
		end
	end

	return var_9_2
end

LevelHelper.get_base_level = function (arg_10_0, arg_10_1)
	local var_10_0 = LevelSettings[arg_10_1]

	return var_10_0 and var_10_0.base_level_name or arg_10_1
end

LevelHelper.get_small_level_image = function (arg_11_0, arg_11_1)
	local var_11_0 = LevelSettings[arg_11_1].small_level_image or arg_11_1 .. "_small_image"

	if not UIAtlasHelper.has_texture_by_name(var_11_0) then
		var_11_0 = "any_small_image"
	end

	return var_11_0
end

LevelHelper.should_load_enemies = function (arg_12_0, arg_12_1)
	return not LevelSettings[arg_12_1].preload_no_enemies
end
