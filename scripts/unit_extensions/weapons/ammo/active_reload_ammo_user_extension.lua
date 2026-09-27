-- chunkname: @scripts/unit_extensions/weapons/ammo/active_reload_ammo_user_extension.lua

local script_data = script_data
local infinite_ammo = script_data.infinite_ammo

infinite_ammo = infinite_ammo or Development.parameter("infinite_ammo")
script_data.infinite_ammo = infinite_ammo
ActiveReloadAmmoUserExtension = class(ActiveReloadAmmoUserExtension)

ActiveReloadAmmoUserExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.world = arg_1_1.world
	self.owner_unit = arg_1_3.owner_unit

	local ammo_data = arg_1_3.ammo_data

	self.reload_time = ammo_data.reload_time
	self.max_ammo = ammo_data.max_ammo

	local start_ammo = ammo_data.start_ammo

	start_ammo = start_ammo or self.max_ammo
	self.start_ammo = start_ammo

	local ammo_per_clip = ammo_data.ammo_per_clip

	ammo_per_clip = ammo_per_clip or self.start_ammo
	self.ammo_per_clip = ammo_per_clip
	self.time_penalty = ammo_data.time_penalty

	if not ScriptUnit.has_extension(self.owner_unit, "first_person_system") then
		self.first_person_extension = ScriptUnit.extension(self.owner_unit, "first_person_system")
	end

	if not ScriptUnit.has_extension(self.owner_unit, "input_system") then
		self.input_extension = ScriptUnit.extension(self.owner_unit, "input_system")
	end

	self._gui = World.create_screen_gui(arg_1_1.world, "immediate")

	self:reset()
end

ActiveReloadAmmoUserExtension.extensions_ready = function (arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	return
end

ActiveReloadAmmoUserExtension.destroy = function (arg_3_0)
	-- function 3
	return
end

ActiveReloadAmmoUserExtension.reset = function (self)
	-- function 4
	self.current_ammo = self.ammo_per_clip
	self.available_ammo = self.start_ammo - self.current_ammo
	self.shots_fired = 0
end

ActiveReloadAmmoUserExtension.update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	if self.shots_fired > 0 then
		self.current_ammo = self.current_ammo - self.shots_fired
		self.shots_fired = 0

		assert(self.current_ammo >= 0)

		if self.current_ammo == 0 then
			Unit.flow_event(arg_5_1, "used_last_ammo")

			if self.available_ammo == 0 then
				local extension = ScriptUnit.extension(self.owner_unit, "inventory_system")
				local equipment = extension:equipment()
				local wielded_slot = equipment.wielded_slot
				local item_data = equipment.slots[wielded_slot].item_data

				if not BackendUtils.get_item_template(item_data).ammo_data.destroy_when_out_of_ammo then
					extension:destroy_slot(wielded_slot)
					extension:wield_previous_weapon()
				end
			end
		end
	end

	if not self.next_reload_time then
		if arg_5_5 > self.next_reload_time then
			if not self.start_reloading then
				self.current_ammo = self.current_ammo + 1
				self.available_ammo = self.available_ammo - 1
			end

			self.start_reloading = nil

			local num = self.ammo_per_clip - self.current_ammo

			if not (not (num > 0) or not (self.available_ammo > 0)) then
				local str = "reload"

				self.next_reload_time = arg_5_5 + self.reload_time

				if not (num == 1 or self.available_ammo ~= 1) then
					str = "reload_last"
				end

				if not self.first_person_extension then
					self.first_person_extension:play_animation_event(str)
				end

				Unit.animation_event(self.owner_unit, str)

				if not LEVEL_EDITOR_TEST then
					Managers.state.network:anim_event(self.owner_unit, str)
				end

				self:_setup_indicator_area()
			else
				self.next_reload_time = nil
			end

			self.event_missed = nil
		end

		if not (not self.next_reload_time and self.event_missed) then
			self:_update_active_reload(arg_5_3, arg_5_5)
			self:_debug_draw(arg_5_3, arg_5_5)
		end
	end
end

local num = 0.2
local num_2 = 0.3

ActiveReloadAmmoUserExtension._update_active_reload = function (self, arg_6_1, arg_6_2)
	-- function 6
	if not self.input_extension:get("weapon_reload") then
		return
	end

	local reload_start_time = self:reload_start_time()

	if arg_6_2 < reload_start_time + self.reload_time * num_2 then
		return
	end

	local num_3 = reload_start_time + self.event_start
	local num_4 = num_3 + num

	if not (not (num_3 <= arg_6_2) or not (arg_6_2 <= num_4)) then
		self.next_reload_time = arg_6_2
	else
		self.next_reload_time = self.next_reload_time + self.time_penalty
		self.event_missed = true
	end
end

ActiveReloadAmmoUserExtension._debug_draw = function (self, arg_7_1, arg_7_2)
	-- function 7
	local _gui = self._gui
	local resolution, var_7_2 = Gui.resolution()
	local var_7_3 = Vector3(resolution * 0.5, var_7_2 * 0.4, 100)
	local var_7_4 = Vector2(150, 35)
	local var_7_5 = Vector3(-var_7_4.x / 2, -var_7_4.y / 2, 0)

	Gui.rect(_gui, var_7_3 + var_7_5, var_7_4, Color(200, 237, 237, 237))

	local num_3 = 1 - (self.next_reload_time - arg_7_2) / self.reload_time
	local var_7_7 = Vector2(3, 35)
	local var_7_8 = Vector3(var_7_4.x * num_3 - var_7_7.x * 0.5, 0, 10)

	Gui.rect(_gui, var_7_3 + var_7_5 + var_7_8, var_7_7, Color(255, 0, 0, 0))

	local event_start = self.event_start
	local num_4 = event_start + num
	local num_5 = event_start / self.reload_time
	local min = math.min(1, 1 - num_4 / self.reload_time)
	local num_6 = num / self.reload_time
	local var_7_14 = Vector2(var_7_4.x * num_6, 35)
	local var_7_15 = Vector3(var_7_4.x * num_5, 0, 5)

	Gui.rect(_gui, var_7_3 + var_7_5 + var_7_15, var_7_14, Color(255, 107, 106, 105))

	local var_7_16 = Vector2(1, 35)
	local var_7_17 = Vector3(var_7_4.x * num_2, 0, 5)

	Gui.rect(_gui, var_7_3 + var_7_5 + var_7_17, var_7_16, Color(255, 255, 0, 0))
end

local num_3 = 0.6

ActiveReloadAmmoUserExtension._setup_indicator_area = function (self)
	-- function 8
	assert(self.next_reload_time)

	local reload_start_time = self:reload_start_time()

	self.event_start = self.reload_time * num_3
end

ActiveReloadAmmoUserExtension.reload_start_time = function (self)
	-- function 9
	assert(self.next_reload_time)

	return self.next_reload_time - self.reload_time
end

ActiveReloadAmmoUserExtension.add_ammo = function (self, arg_10_1)
	-- function 10
	self.available_ammo = math.min(self.available_ammo + arg_10_1, self.max_ammo - (self.current_ammo - self.shots_fired))
end

ActiveReloadAmmoUserExtension.use_ammo = function (self, arg_11_1)
	-- function 11
	self.shots_fired = self.shots_fired + arg_11_1

	assert(self:ammo_count() >= 0)
end

ActiveReloadAmmoUserExtension.start_reload = function (self, arg_12_1)
	-- function 12
	assert(self:can_reload())
	assert(self.next_reload_time == nil)

	self.start_reloading = true
	self.next_reload_time = 0
end

ActiveReloadAmmoUserExtension.abort_reload = function (self)
	-- function 13
	assert(self:is_reloading())

	self.start_reloading = nil
	self.next_reload_time = nil
end

ActiveReloadAmmoUserExtension.ammo_count = function (self)
	-- function 14
	return self.current_ammo - self.shots_fired
end

ActiveReloadAmmoUserExtension.clip_size = function (self)
	-- function 15
	return self.ammo_per_clip
end

ActiveReloadAmmoUserExtension.remaining_ammo = function (self)
	-- function 16
	return self.available_ammo
end

ActiveReloadAmmoUserExtension.can_reload = function (self)
	-- function 17
	if not self:is_reloading() then
		return false
	end

	if self:ammo_count() == self.ammo_per_clip then
		return false
	end

	if not script_data.infinite_ammo then
		return true
	end

	return self.available_ammo > 0
end

ActiveReloadAmmoUserExtension.is_reloading = function (self)
	-- function 18
	return self.next_reload_time ~= nil
end
