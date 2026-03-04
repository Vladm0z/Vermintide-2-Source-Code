-- chunkname: @scripts/settings/dlcs/anvil/anvil_pickup_settings.lua

local var_0_0 = DLCSettings.anvil
local var_0_1 = {
	only_once = true,
	refill_amount = 1,
	type = "ammo",
	spawn_weighting = 1e-06,
	debug_pickup_category = "throwing_weapons",
	pickup_sound_event = "pickup_ammo",
	outline_distance = "small_pickup",
	consumable_item = true,
	local_pickup_sound = true,
	hud_description = "interaction_ammunition_axe",
	ammo_kind = "thrown",
	can_interact_func = function (arg_1_0, arg_1_1, arg_1_2)
		local var_1_0 = ScriptUnit.has_extension(arg_1_0, "inventory_system")

		if not var_1_0 then
			return false
		end

		return var_1_0:has_ammo_consuming_weapon_equipped("throwing_axe")
	end,
	outline_available_func = function (arg_2_0)
		local var_2_0 = ScriptUnit.has_extension(arg_2_0, "inventory_system")

		if not var_2_0 then
			return false
		end

		return var_2_0:has_ammo_consuming_weapon_equipped("throwing_axe")
	end,
	on_pick_up_func = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
		local var_3_0 = Network.peer_id()

		Managers.state.entity:system("pickup_system"):delete_limited_owned_pickup_unit(var_3_0, arg_3_3)
	end
}
local var_0_2 = {
	ammo_throwing_axe_01_t1 = {
		unit_template_name = "limited_owned_pickup_projectile_unit",
		unit_name = "units/weapons/player/wpn_dw_thrown_axe_01_t1/pup_dw_thrown_axe_01_t1",
		category = "ammo"
	},
	ammo_throwing_axe_01_t1_runed_01 = {
		unit_template_name = "limited_owned_pickup_projectile_unit",
		unit_name = "units/weapons/player/wpn_dw_thrown_axe_01_t1/pup_dw_thrown_axe_01_t1_runed_01",
		category = "ammo"
	},
	ammo_throwing_axe_01_t2 = {
		unit_template_name = "limited_owned_pickup_projectile_unit",
		unit_name = "units/weapons/player/wpn_dw_thrown_axe_01_t2/pup_dw_thrown_axe_01_t2",
		category = "ammo"
	},
	link_ammo_throwing_axe_01_t1 = {
		unit_template_name = "limited_owned_pickup_unit",
		unit_name = "units/weapons/player/wpn_dw_thrown_axe_01_t1/pup_dw_thrown_axe_01_t1",
		category = "ammo"
	},
	link_ammo_throwing_axe_01_t1_runed_01 = {
		unit_template_name = "limited_owned_pickup_unit",
		unit_name = "units/weapons/player/wpn_dw_thrown_axe_01_t1/pup_dw_thrown_axe_01_t1_runed_01",
		category = "ammo"
	},
	link_ammo_throwing_axe_01_t2 = {
		unit_template_name = "limited_owned_pickup_unit",
		unit_name = "units/weapons/player/wpn_dw_thrown_axe_01_t2/pup_dw_thrown_axe_01_t2",
		category = "ammo"
	}
}

var_0_0.pickups = {}

for iter_0_0, iter_0_1 in pairs(var_0_2) do
	if not var_0_0.pickups[iter_0_1.category] then
		var_0_0.pickups[iter_0_1.category] = {}
	end

	local var_0_3 = iter_0_1.category

	var_0_0.pickups[var_0_3][iter_0_0] = table.clone(var_0_1)
	var_0_0.pickups[var_0_3][iter_0_0].unit_name = iter_0_1.unit_name
	var_0_0.pickups[var_0_3][iter_0_0].unit_template_name = iter_0_1.unit_template_name
end
