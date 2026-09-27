-- chunkname: @scripts/unit_extensions/default_player_unit/player_hud.lua

local num = 26
local str = "arial"
local str_2 = "materials/fonts/" .. str

PlayerHud = class(PlayerHud)

PlayerHud.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.world = arg_1_1.world
	self.gui = World.create_screen_gui(self.world, "material", "materials/fonts/gw_fonts", "immediate")
	self.raycast_state = "waiting_to_raycast"
	self.raycast_target = nil
	self.physics_world = World.get_data(arg_1_1.world, "physics_world")
	self.current_location = nil
	self.picked_up_ammo = false
	self.hit_marker_data = {}

	self:reset()
end

PlayerHud.extensions_ready = function (arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	return
end

PlayerHud.destroy = function (arg_3_0)
	-- function 3
	return
end

PlayerHud.reset = function (self)
	-- function 4
	self.outline_timers = {}
end

local flag = true

PlayerHud.update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	return
end

PlayerHud.draw_player_names = function (self, arg_6_1)
	-- function 6
	local players = Managers.player:players()
	local str_3 = "player_1"
	local viewport = ScriptWorld.viewport(self.world, str_3)
	local camera = ScriptViewport.camera(viewport)
	local res_w = RESOLUTION_LOOKUP.res_w
	local res_h = RESOLUTION_LOOKUP.res_h
	local var_6_6 = Vector3(res_w / 2, res_h / 2, 0)
	local num_2 = res_h / 3
	local num_3 = num_2 * num_2
	local gui = self.gui
	local var_6_10 = Vector3(0, 0, 0.925)

	for k, v in pairs(players) do
		local name = v:name()

		if not (not v.player_unit and v.player_unit == arg_6_1) then
			local num_4 = Unit.local_position(v.player_unit, 0) + var_6_10
			local num_5 = num_4 + var_6_10

			if Camera.inside_frustum(camera, num_4) > 0 then
				local text_extents, var_6_15 = Gui.text_extents(gui, name, str_2, num)
				local num_6 = var_6_15.x - text_extents.x
				local world_to_screen = Camera.world_to_screen(camera, num_4)
				local var_6_18 = Vector3(world_to_screen.x, world_to_screen.z, 0)
				local world_to_screen_2 = Camera.world_to_screen(camera, num_5)
				local var_6_20 = Vector3(world_to_screen_2.x - num_6 / 2, world_to_screen_2.z, 0)
				local distance_squared = Vector3.distance_squared(var_6_18, var_6_6)
				local num_7 = math.max(num_3 - distance_squared, 0) / num_3
				local var_6_23 = Color(255 * num_7, 0, 200, 200)

				Gui.text(gui, name, str_2, num, str, var_6_20, var_6_23)
			end
		end
	end
end

PlayerHud.set_current_location = function (self, arg_7_1)
	-- function 7
	self.current_location = arg_7_1
end

PlayerHud.block_current_location_ui = function (self, arg_8_1)
	-- function 8
	self.location_ui_blocked = arg_8_1
end

PlayerHud.gdc_intro_active = function (self, arg_9_1)
	-- function 9
	self.show_gdc_intro = true
end

PlayerHud.set_picked_up_ammo = function (self, arg_10_1)
	-- function 10
	self.picked_up_ammo = arg_10_1
end

PlayerHud.get_picked_up_ammo = function (self)
	-- function 11
	return self.picked_up_ammo
end
