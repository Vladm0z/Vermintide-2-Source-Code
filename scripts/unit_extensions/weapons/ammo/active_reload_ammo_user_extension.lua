-- chunkname: @scripts/unit_extensions/weapons/ammo/active_reload_ammo_user_extension.lua

script_data.infinite_ammo = script_data.infinite_ammo or Development.parameter("infinite_ammo")
ActiveReloadAmmoUserExtension = class(ActiveReloadAmmoUserExtension)

function ActiveReloadAmmoUserExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.world = arg_1_1.world
	arg_1_0.owner_unit = arg_1_3.owner_unit

	local var_1_0 = arg_1_3.ammo_data

	arg_1_0.reload_time = var_1_0.reload_time
	arg_1_0.max_ammo = var_1_0.max_ammo
	arg_1_0.start_ammo = var_1_0.start_ammo or arg_1_0.max_ammo
	arg_1_0.ammo_per_clip = var_1_0.ammo_per_clip or arg_1_0.start_ammo
	arg_1_0.time_penalty = var_1_0.time_penalty

	if ScriptUnit.has_extension(arg_1_0.owner_unit, "first_person_system") then
		arg_1_0.first_person_extension = ScriptUnit.extension(arg_1_0.owner_unit, "first_person_system")
	end

	if ScriptUnit.has_extension(arg_1_0.owner_unit, "input_system") then
		arg_1_0.input_extension = ScriptUnit.extension(arg_1_0.owner_unit, "input_system")
	end

	arg_1_0._gui = World.create_screen_gui(arg_1_1.world, "immediate")

	arg_1_0:reset()
end

function ActiveReloadAmmoUserExtension.extensions_ready(arg_2_0, arg_2_1, arg_2_2)
	return
end

function ActiveReloadAmmoUserExtension.destroy(arg_3_0)
	return
end

function ActiveReloadAmmoUserExtension.reset(arg_4_0)
	arg_4_0.current_ammo = arg_4_0.ammo_per_clip
	arg_4_0.available_ammo = arg_4_0.start_ammo - arg_4_0.current_ammo
	arg_4_0.shots_fired = 0
end

function ActiveReloadAmmoUserExtension.update(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	if arg_5_0.shots_fired > 0 then
		arg_5_0.current_ammo = arg_5_0.current_ammo - arg_5_0.shots_fired
		arg_5_0.shots_fired = 0

		assert(arg_5_0.current_ammo >= 0)

		if arg_5_0.current_ammo == 0 then
			Unit.flow_event(arg_5_1, "used_last_ammo")

			if arg_5_0.available_ammo == 0 then
				local var_5_0 = ScriptUnit.extension(arg_5_0.owner_unit, "inventory_system")
				local var_5_1 = var_5_0:equipment()
				local var_5_2 = var_5_1.wielded_slot
				local var_5_3 = var_5_1.slots[var_5_2].item_data

				if BackendUtils.get_item_template(var_5_3).ammo_data.destroy_when_out_of_ammo then
					var_5_0:destroy_slot(var_5_2)
					var_5_0:wield_previous_weapon()
				end
			end
		end
	end

	if arg_5_0.next_reload_time then
		if arg_5_5 > arg_5_0.next_reload_time then
			if not arg_5_0.start_reloading then
				arg_5_0.current_ammo = arg_5_0.current_ammo + 1
				arg_5_0.available_ammo = arg_5_0.available_ammo - 1
			end

			arg_5_0.start_reloading = nil

			local var_5_4 = arg_5_0.ammo_per_clip - arg_5_0.current_ammo

			if var_5_4 > 0 and arg_5_0.available_ammo > 0 then
				local var_5_5 = "reload"

				arg_5_0.next_reload_time = arg_5_5 + arg_5_0.reload_time

				if var_5_4 == 1 or arg_5_0.available_ammo == 1 then
					var_5_5 = "reload_last"
				end

				if arg_5_0.first_person_extension then
					arg_5_0.first_person_extension:play_animation_event(var_5_5)
				end

				Unit.animation_event(arg_5_0.owner_unit, var_5_5)

				if not LEVEL_EDITOR_TEST then
					Managers.state.network:anim_event(arg_5_0.owner_unit, var_5_5)
				end

				arg_5_0:_setup_indicator_area()
			else
				arg_5_0.next_reload_time = nil
			end

			arg_5_0.event_missed = nil
		end

		if arg_5_0.next_reload_time and not arg_5_0.event_missed then
			arg_5_0:_update_active_reload(arg_5_3, arg_5_5)
			arg_5_0:_debug_draw(arg_5_3, arg_5_5)
		end
	end
end

local var_0_0 = 0.2
local var_0_1 = 0.3

function ActiveReloadAmmoUserExtension._update_active_reload(arg_6_0, arg_6_1, arg_6_2)
	if not arg_6_0.input_extension:get("weapon_reload") then
		return
	end

	local var_6_0 = arg_6_0:reload_start_time()

	if arg_6_2 < var_6_0 + arg_6_0.reload_time * var_0_1 then
		return
	end

	local var_6_1 = var_6_0 + arg_6_0.event_start
	local var_6_2 = var_6_1 + var_0_0

	if var_6_1 <= arg_6_2 and arg_6_2 <= var_6_2 then
		arg_6_0.next_reload_time = arg_6_2
	else
		arg_6_0.next_reload_time = arg_6_0.next_reload_time + arg_6_0.time_penalty
		arg_6_0.event_missed = true
	end
end

function ActiveReloadAmmoUserExtension._debug_draw(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0._gui
	local var_7_1, var_7_2 = Gui.resolution()
	local var_7_3 = Vector3(var_7_1 * 0.5, var_7_2 * 0.4, 100)
	local var_7_4 = Vector2(150, 35)
	local var_7_5 = Vector3(-var_7_4.x / 2, -var_7_4.y / 2, 0)

	Gui.rect(var_7_0, var_7_3 + var_7_5, var_7_4, Color(200, 237, 237, 237))

	local var_7_6 = 1 - (arg_7_0.next_reload_time - arg_7_2) / arg_7_0.reload_time
	local var_7_7 = Vector2(3, 35)
	local var_7_8 = Vector3(var_7_4.x * var_7_6 - var_7_7.x * 0.5, 0, 10)

	Gui.rect(var_7_0, var_7_3 + var_7_5 + var_7_8, var_7_7, Color(255, 0, 0, 0))

	local var_7_9 = arg_7_0.event_start
	local var_7_10 = var_7_9 + var_0_0
	local var_7_11 = var_7_9 / arg_7_0.reload_time
	local var_7_12 = math.min(1, 1 - var_7_10 / arg_7_0.reload_time)
	local var_7_13 = var_0_0 / arg_7_0.reload_time
	local var_7_14 = Vector2(var_7_4.x * var_7_13, 35)
	local var_7_15 = Vector3(var_7_4.x * var_7_11, 0, 5)

	Gui.rect(var_7_0, var_7_3 + var_7_5 + var_7_15, var_7_14, Color(255, 107, 106, 105))

	local var_7_16 = Vector2(1, 35)
	local var_7_17 = Vector3(var_7_4.x * var_0_1, 0, 5)

	Gui.rect(var_7_0, var_7_3 + var_7_5 + var_7_17, var_7_16, Color(255, 255, 0, 0))
end

local var_0_2 = 0.6

function ActiveReloadAmmoUserExtension._setup_indicator_area(arg_8_0)
	assert(arg_8_0.next_reload_time)

	local var_8_0 = arg_8_0:reload_start_time()

	arg_8_0.event_start = arg_8_0.reload_time * var_0_2
end

function ActiveReloadAmmoUserExtension.reload_start_time(arg_9_0)
	assert(arg_9_0.next_reload_time)

	return arg_9_0.next_reload_time - arg_9_0.reload_time
end

function ActiveReloadAmmoUserExtension.add_ammo(arg_10_0, arg_10_1)
	arg_10_0.available_ammo = math.min(arg_10_0.available_ammo + arg_10_1, arg_10_0.max_ammo - (arg_10_0.current_ammo - arg_10_0.shots_fired))
end

function ActiveReloadAmmoUserExtension.use_ammo(arg_11_0, arg_11_1)
	arg_11_0.shots_fired = arg_11_0.shots_fired + arg_11_1

	assert(arg_11_0:ammo_count() >= 0)
end

function ActiveReloadAmmoUserExtension.start_reload(arg_12_0, arg_12_1)
	assert(arg_12_0:can_reload())
	assert(arg_12_0.next_reload_time == nil)

	arg_12_0.start_reloading = true
	arg_12_0.next_reload_time = 0
end

function ActiveReloadAmmoUserExtension.abort_reload(arg_13_0)
	assert(arg_13_0:is_reloading())

	arg_13_0.start_reloading = nil
	arg_13_0.next_reload_time = nil
end

function ActiveReloadAmmoUserExtension.ammo_count(arg_14_0)
	return arg_14_0.current_ammo - arg_14_0.shots_fired
end

function ActiveReloadAmmoUserExtension.clip_size(arg_15_0)
	return arg_15_0.ammo_per_clip
end

function ActiveReloadAmmoUserExtension.remaining_ammo(arg_16_0)
	return arg_16_0.available_ammo
end

function ActiveReloadAmmoUserExtension.can_reload(arg_17_0)
	if arg_17_0:is_reloading() then
		return false
	end

	if arg_17_0:ammo_count() == arg_17_0.ammo_per_clip then
		return false
	end

	if script_data.infinite_ammo then
		return true
	end

	return arg_17_0.available_ammo > 0
end

function ActiveReloadAmmoUserExtension.is_reloading(arg_18_0)
	return arg_18_0.next_reload_time ~= nil
end
