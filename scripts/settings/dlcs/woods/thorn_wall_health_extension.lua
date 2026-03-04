-- chunkname: @scripts/settings/dlcs/woods/thorn_wall_health_extension.lua

ThornWallHealthExtension = class(ThornWallHealthExtension, GenericHealthExtension)

local var_0_0 = Unit.alive
local var_0_1 = Unit.flow_event
local var_0_2 = Unit.set_flow_variable

ThornWallHealthExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	ThornWallHealthExtension.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
end

ThornWallHealthExtension.extensions_ready = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	return
end

ThornWallHealthExtension.destroy = function (arg_3_0)
	ThornWallHealthExtension.super.destroy(arg_3_0)
end

ThornWallHealthExtension.apply_client_predicted_damage = function (arg_4_0, arg_4_1)
	return
end

local var_0_3 = {
	chaos_exalted_champion_norsca = true,
	chaos_exalted_champion_warcamp = true,
	skaven_storm_vermin_warlord = true
}

ThornWallHealthExtension.add_damage = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8, arg_5_9, arg_5_10, arg_5_11, arg_5_12, arg_5_13, arg_5_14, arg_5_15, arg_5_16, arg_5_17)
	local var_5_0 = arg_5_0.unit
	local var_5_1 = DamageUtils.is_enemy(arg_5_1, var_5_0)
	local var_5_2 = 0

	if var_0_3[arg_5_7] then
		var_5_2 = 100
	end

	Managers.state.achievement:trigger_event("register_thorn_wall_damage", arg_5_0.unit, arg_5_1, var_5_2, arg_5_15)

	if var_5_1 or arg_5_15 == "heavy_attack" or arg_5_15 == "light_attack" then
		ThornWallHealthExtension.super.add_damage(arg_5_0, arg_5_1, var_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8, arg_5_9, arg_5_10, arg_5_11, arg_5_12, arg_5_13, arg_5_14, arg_5_15, arg_5_16, arg_5_17)

		if var_5_0 and var_0_0(var_5_0) then
			var_0_2(var_5_0, "hit_direction", arg_5_6)
			var_0_2(var_5_0, "hit_position", arg_5_5)
			var_0_1(var_5_0, "lua_simple_damage")
		end
	end
end
