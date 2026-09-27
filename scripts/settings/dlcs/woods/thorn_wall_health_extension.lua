-- chunkname: @scripts/settings/dlcs/woods/thorn_wall_health_extension.lua

ThornWallHealthExtension = class(ThornWallHealthExtension, GenericHealthExtension)

local alive = Unit.alive
local flow_event = Unit.flow_event
local set_flow_variable = Unit.set_flow_variable

ThornWallHealthExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	ThornWallHealthExtension.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
end

ThornWallHealthExtension.extensions_ready = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	return
end

ThornWallHealthExtension.destroy = function (arg_3_0)
	-- function 3
	ThornWallHealthExtension.super.destroy(arg_3_0)
end

ThornWallHealthExtension.apply_client_predicted_damage = function (arg_4_0, arg_4_1)
	-- function 4
	return
end

local tbl = {
	chaos_exalted_champion_norsca = true,
	chaos_exalted_champion_warcamp = true,
	skaven_storm_vermin_warlord = true
}

ThornWallHealthExtension.add_damage = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8, arg_5_9, arg_5_10, arg_5_11, arg_5_12, arg_5_13, arg_5_14, arg_5_15, arg_5_16, arg_5_17)
	-- function 5
	local unit = self.unit
	local is_enemy = DamageUtils.is_enemy(arg_5_1, unit)
	local num = 0

	if not tbl[arg_5_7] then
		num = 100
	end

	Managers.state.achievement:trigger_event("register_thorn_wall_damage", self.unit, arg_5_1, num, arg_5_15)

	if not (is_enemy or arg_5_15 == "heavy_attack" or arg_5_15 ~= "light_attack") then
		ThornWallHealthExtension.super.add_damage(self, arg_5_1, num, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8, arg_5_9, arg_5_10, arg_5_11, arg_5_12, arg_5_13, arg_5_14, arg_5_15, arg_5_16, arg_5_17)

		if not unit and not alive(unit) then
			set_flow_variable(unit, "hit_direction", arg_5_6)
			set_flow_variable(unit, "hit_position", arg_5_5)
			flow_event(unit, "lua_simple_damage")
		end
	end
end
