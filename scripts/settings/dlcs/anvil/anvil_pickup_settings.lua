-- chunkname: @scripts/settings/dlcs/anvil/anvil_pickup_settings.lua

local anvil = DLCSettings.anvil
local tbl = {
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
		-- function 1
		local has_extension = ScriptUnit.has_extension(arg_1_0, "inventory_system")

		if not has_extension then
			return false
		end

		return has_extension:has_ammo_consuming_weapon_equipped("throwing_axe")
	end,
	outline_available_func = function (arg_2_0)
		-- function 2
		local has_extension = ScriptUnit.has_extension(arg_2_0, "inventory_system")

		if not has_extension then
			return false
		end

		return has_extension:has_ammo_consuming_weapon_equipped("throwing_axe")
	end,
	on_pick_up_func = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
		-- function 3
		local peer_id = Network.peer_id()

		Managers.state.entity:system("pickup_system"):delete_limited_owned_pickup_unit(peer_id, arg_3_3)
	end
}
local tbl_2 = {
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

anvil.pickups = {}

for k, v in pairs(tbl_2) do
	if not anvil.pickups[v.category] then
		anvil.pickups[v.category] = {}
	end

	local category = v.category

	anvil.pickups[category][k] = table.clone(tbl)
	anvil.pickups[category][k].unit_name = v.unit_name
	anvil.pickups[category][k].unit_template_name = v.unit_template_name
end
