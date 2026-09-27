-- chunkname: @scripts/helpers/level_helper.lua

local LevelHelper = LevelHelper

LevelHelper = LevelHelper or {}
LevelHelper = LevelHelper
LevelHelper.INGAME_WORLD_NAME = "level_world"

LevelHelper.current_level_settings = function (arg_1_0)
	-- function 1
	if not Managers.state.game_mode then
		local level_key = Managers.state.game_mode:level_key()

		return LevelSettings[level_key]
	end

	return nil
end

LevelHelper.current_level = function (self, arg_2_1)
	-- function 2
	local current_level_settings = self:current_level_settings()

	return (ScriptWorld.level(arg_2_1, current_level_settings.level_name))
end

LevelHelper.get_environment_variation_id = function (self, arg_3_1)
	-- function 3
	local get_title_data = Managers.backend:get_title_data("environment_variations")

	if not get_title_data then
		return self:get_random_variation_id(arg_3_1)
	end

	local var_3_1 = cjson.decode(get_title_data)[arg_3_1]

	if not var_3_1 then
		return 0
	end

	local type = var_3_1.type

	if type == "random" then
		return self:get_random_variation_id(arg_3_1)
	elseif type == "specific" then
		local var_3_3 = LevelSettings[arg_3_1]
		local flag = not var_3_3 and var_3_3.environment_variations

		if not (not flag and not (#flag < 1)) then
			return 0
		end

		local variations = var_3_1.variations
		local var_3_6
		local var_3_7
		local var_3_8

		while #variations > 0 do
			local random = math.random(1, #variations)
			local var_3_10 = variations[random]

			if var_3_10 == "default" then
				return 0
			end

			local find = table.find(flag, var_3_10)

			if not find then
				return find
			else
				table.remove(variations, random)
			end
		end
	elseif type == "default" then
		return 0
	end

	return 0
end

LevelHelper.get_random_variation_id = function (arg_4_0, arg_4_1)
	-- function 4
	local var_4_0 = rawget(LevelSettings, arg_4_1)
	local flag = not var_4_0 and var_4_0.environment_variations
	local random

	if not flag then
		random = math.random(0, #flag)

		if not random then
			-- Nothing
		end
	end

	random = 0

	::label_4_0::

	return random
end

LevelHelper.flow_event = function (self, arg_5_1, arg_5_2)
	-- function 5
	local current_level_settings = self:current_level_settings()
	local level = ScriptWorld.level(arg_5_1, current_level_settings.level_name)

	Level.trigger_event(level, arg_5_2)
end

LevelHelper.set_flow_parameter = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local current_level_settings = self:current_level_settings()
	local level = ScriptWorld.level(arg_6_1, current_level_settings.level_name)

	Level.set_flow_variable(level, arg_6_2, arg_6_3)
end

LevelHelper.unit_index = function (self, arg_7_1, arg_7_2)
	-- function 7
	local current_level = self:current_level(arg_7_1)

	return Level.unit_index(current_level, arg_7_2)
end

LevelHelper.unit_by_index = function (self, arg_8_1, arg_8_2)
	-- function 8
	local current_level = self:current_level(arg_8_1)

	return Level.unit_by_index(current_level, arg_8_2)
end

LevelHelper.find_dialogue_unit = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	local current_level = LevelHelper:current_level(arg_9_1)
	local units = Level.units(current_level)
	local var_9_2

	for i, v in ipairs(units) do
		if not (not Unit.has_data(v, "dialogue_profile") and Unit.get_data(v, "dialogue_profile") ~= arg_9_2) then
			var_9_2 = v

			break
		end
	end

	return var_9_2
end

LevelHelper.get_base_level = function (arg_10_0, arg_10_1)
	-- function 10
	local var_10_0 = LevelSettings[arg_10_1]
	local base_level_name

	if not var_10_0 then
		base_level_name = var_10_0.base_level_name

		if not base_level_name then
			-- Nothing
		end
	end

	base_level_name = arg_10_1

	::label_10_0::

	return base_level_name
end

LevelHelper.get_small_level_image = function (arg_11_0, arg_11_1)
	-- function 11
	local small_level_image = LevelSettings[arg_11_1].small_level_image

	small_level_image = small_level_image or arg_11_1 .. "_small_image"

	if not UIAtlasHelper.has_texture_by_name(small_level_image) then
		small_level_image = "any_small_image"
	end

	return small_level_image
end

LevelHelper.should_load_enemies = function (arg_12_0, arg_12_1)
	-- function 12
	return not LevelSettings[arg_12_1].preload_no_enemies
end
