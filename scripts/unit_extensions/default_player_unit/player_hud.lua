-- chunkname: @scripts/unit_extensions/default_player_unit/player_hud.lua

local var_0_0 = 26
local var_0_1 = "arial"
local var_0_2 = "materials/fonts/" .. var_0_1

PlayerHud = class(PlayerHud)

function PlayerHud.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.world = arg_1_1.world
	arg_1_0.gui = World.create_screen_gui(arg_1_0.world, "material", "materials/fonts/gw_fonts", "immediate")
	arg_1_0.raycast_state = "waiting_to_raycast"
	arg_1_0.raycast_target = nil
	arg_1_0.physics_world = World.get_data(arg_1_1.world, "physics_world")
	arg_1_0.current_location = nil
	arg_1_0.picked_up_ammo = false
	arg_1_0.hit_marker_data = {}

	arg_1_0:reset()
end

function PlayerHud.extensions_ready(arg_2_0, arg_2_1, arg_2_2)
	return
end

function PlayerHud.destroy(arg_3_0)
	return
end

function PlayerHud.reset(arg_4_0)
	arg_4_0.outline_timers = {}
end

local var_0_3 = true

function PlayerHud.update(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	return
end

function PlayerHud.draw_player_names(arg_6_0, arg_6_1)
	local var_6_0 = Managers.player:players()
	local var_6_1 = "player_1"
	local var_6_2 = ScriptWorld.viewport(arg_6_0.world, var_6_1)
	local var_6_3 = ScriptViewport.camera(var_6_2)
	local var_6_4 = RESOLUTION_LOOKUP.res_w
	local var_6_5 = RESOLUTION_LOOKUP.res_h
	local var_6_6 = Vector3(var_6_4 / 2, var_6_5 / 2, 0)
	local var_6_7 = var_6_5 / 3
	local var_6_8 = var_6_7 * var_6_7
	local var_6_9 = arg_6_0.gui
	local var_6_10 = Vector3(0, 0, 0.925)

	for iter_6_0, iter_6_1 in pairs(var_6_0) do
		local var_6_11 = iter_6_1:name()

		if iter_6_1.player_unit and iter_6_1.player_unit ~= arg_6_1 then
			local var_6_12 = Unit.local_position(iter_6_1.player_unit, 0) + var_6_10
			local var_6_13 = var_6_12 + var_6_10

			if Camera.inside_frustum(var_6_3, var_6_12) > 0 then
				local var_6_14, var_6_15 = Gui.text_extents(var_6_9, var_6_11, var_0_2, var_0_0)
				local var_6_16 = var_6_15.x - var_6_14.x
				local var_6_17 = Camera.world_to_screen(var_6_3, var_6_12)
				local var_6_18 = Vector3(var_6_17.x, var_6_17.z, 0)
				local var_6_19 = Camera.world_to_screen(var_6_3, var_6_13)
				local var_6_20 = Vector3(var_6_19.x - var_6_16 / 2, var_6_19.z, 0)
				local var_6_21 = Vector3.distance_squared(var_6_18, var_6_6)
				local var_6_22 = math.max(var_6_8 - var_6_21, 0) / var_6_8
				local var_6_23 = Color(255 * var_6_22, 0, 200, 200)

				Gui.text(var_6_9, var_6_11, var_0_2, var_0_0, var_0_1, var_6_20, var_6_23)
			end
		end
	end
end

function PlayerHud.set_current_location(arg_7_0, arg_7_1)
	arg_7_0.current_location = arg_7_1
end

function PlayerHud.block_current_location_ui(arg_8_0, arg_8_1)
	arg_8_0.location_ui_blocked = arg_8_1
end

function PlayerHud.gdc_intro_active(arg_9_0, arg_9_1)
	arg_9_0.show_gdc_intro = true
end

function PlayerHud.set_picked_up_ammo(arg_10_0, arg_10_1)
	arg_10_0.picked_up_ammo = arg_10_1
end

function PlayerHud.get_picked_up_ammo(arg_11_0)
	return arg_11_0.picked_up_ammo
end
