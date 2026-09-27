-- chunkname: @scripts/settings/mutators/mutator_blessing_of_abundance.lua

require("scripts/settings/dlcs/morris/deus_blessing_settings")

local num = 1
local tbl = {
	{
		drop_weight = 500,
		pickup_name = "frag_grenade_t1",
		spawn_function = "spawn_pickup_at_unit"
	},
	{
		drop_weight = 500,
		pickup_name = "frag_grenade_t2",
		spawn_function = "spawn_pickup_at_unit"
	},
	{
		drop_weight = 500,
		pickup_name = "fire_grenade_t1",
		spawn_function = "spawn_pickup_at_unit"
	},
	{
		drop_weight = 500,
		pickup_name = "fire_grenade_t2",
		spawn_function = "spawn_pickup_at_unit"
	},
	{
		drop_weight = 10,
		pickup_name = "holy_hand_grenade",
		spawn_function = "spawn_pickup_at_unit"
	},
	{
		drop_weight = 2000,
		pickup_name = "all_ammo_small",
		spawn_function = "spawn_pickup_at_unit"
	},
	{
		drop_weight = 500,
		pickup_name = "liquid_bravado_potion",
		spawn_function = "spawn_pickup_at_unit"
	},
	{
		drop_weight = 500,
		pickup_name = "friendly_murderer_potion",
		spawn_function = "spawn_pickup_at_unit"
	},
	{
		drop_weight = 500,
		pickup_name = "killer_in_the_shadows_potion",
		spawn_function = "spawn_pickup_at_unit"
	},
	{
		drop_weight = 500,
		pickup_name = "pockets_full_of_bombs_potion",
		spawn_function = "spawn_pickup_at_unit"
	},
	{
		drop_weight = 500,
		pickup_name = "hold_my_beer_potion",
		spawn_function = "spawn_pickup_at_unit"
	},
	{
		drop_weight = 500,
		pickup_name = "moot_milk_potion",
		spawn_function = "spawn_pickup_at_unit"
	},
	{
		drop_weight = 500,
		pickup_name = "vampiric_draught_potion",
		spawn_function = "spawn_pickup_at_unit"
	}
}
local var_0_2 = (function ()
	-- function 1
	local tbl_2 = {}
	local num = 0

	for i, v in ipairs(tbl) do
		num = num + v.drop_weight
	end

	for k = 1, #tbl do
		local num_2 = tbl[k].drop_weight / num

		tbl_2[k] = tbl[k]
		tbl_2[k].drop_weight = num_2
	end

	return tbl_2
end)()

local function fn(self, arg_2_1)
	-- function 2
	local num = 0

	for i, v in ipairs(self) do
		num = num + v.drop_weight

		if arg_2_1 < num then
			return v
		end
	end

	assert(self[1], "Does not contain first entry. Something went wrong.")

	return self[1]
end

local tbl_2 = {
	spawn_pickup_at_unit = function (arg_3_0, arg_3_1)
		-- function 3
		local num = POSITION_LOOKUP[arg_3_0] + Vector3.up() * 0.1
		local flag = true
		local pickup_name = arg_3_1.pickup_name

		Managers.state.entity:system("pickup_system"):buff_spawn_pickup(pickup_name, num, flag)
	end,
	spawn_ignited_barrel_at_unit = function (arg_4_0, arg_4_1)
		-- function 4
		local num = POSITION_LOOKUP[arg_4_0] + Vector3.up() * 0.1
		local identity = Quaternion.identity()
		local position_network_scale = AiAnimUtils.position_network_scale(num, true)
		local rotation_network_scale = AiAnimUtils.rotation_network_scale(identity, true)
		local velocity_network_scale = AiAnimUtils.velocity_network_scale(Vector3(0, 0, 0), true)
		local pickup_name = arg_4_1.pickup_name
		local time = Managers.time:time("game")
		local tbl = {
			explode_time = time + arg_4_1.explode_time,
			fuse_time = arg_4_1.fuse_time
		}
		local tbl_2 = {
			projectile_locomotion_system = {
				network_position = position_network_scale,
				network_rotation = rotation_network_scale,
				network_velocity = velocity_network_scale,
				network_angular_velocity = velocity_network_scale
			},
			death_system = {
				in_hand = false,
				death_data = tbl,
				item_name = pickup_name
			},
			health_system = {
				damage = 1,
				health_data = tbl,
				item_name = pickup_name
			},
			pickup_system = {
				has_physics = true,
				spawn_type = "loot",
				pickup_name = pickup_name
			}
		}
		local var_4_9 = AllPickups[pickup_name]
		local unit_name = var_4_9.unit_name
		local unit_template_name = var_4_9.unit_template_name

		unit_template_name = unit_template_name or "pickup_unit"

		Managers.state.unit_spawner:spawn_network_unit(unit_name, unit_template_name, tbl_2, num, identity)
	end
}

return {
	display_name = DeusBlessingSettings.blessing_of_abundance.display_name,
	description = DeusBlessingSettings.blessing_of_abundance.description,
	icon = DeusBlessingSettings.blessing_of_abundance.icon,
	server_start_function = function (arg_5_0, arg_5_1, arg_5_2)
		-- function 5
		arg_5_1.seed = Managers.mechanism:get_level_seed("mutator")
	end,
	server_ai_killed_function = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		-- function 6
		local get_data = Unit.get_data(arg_6_2, "breed")

		if not (get_data.special or get_data.elite or get_data.boss) then
			return
		end

		local var_6_1
		local var_6_2

		arg_6_1.seed, var_6_2 = Math.next_random(arg_6_1.seed)

		if var_6_2 <= num then
			local var_6_3

			arg_6_1.seed, var_6_3 = Math.next_random(arg_6_1.seed)

			local clone = table.clone(var_0_2)

			table.array_remove_if(clone, function (self)
				-- function 7
				return self.pickup_name == arg_6_1.last_dropped_pickup
			end)

			local var_6_5 = fn(clone, var_6_3)
			local spawn_function = var_6_5.spawn_function

			tbl_2[spawn_function](arg_6_2, var_6_5)

			arg_6_1.last_dropped_pickup = var_6_5.pickup_name
		end
	end
}
