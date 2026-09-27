-- chunkname: @scripts/settings/equipment/weapon_templates/packmaster_claw.lua

local tbl = {
	actions = {}
}

tbl.right_hand_unit = "units/weapons/player/wpn_packmaster_claw/wpn_packmaster_claw"
tbl.right_hand_attachment_node_linking = AttachmentNodeLinking.packmaster_claw
tbl.wield_anim = "to_packmaster_claw"
tbl.state_machine = "units/beings/player/first_person_base/state_machines/common"
tbl.load_state_machine = false
tbl.mechanism_overrides = {
	versus = {
		right_hand_unit = "units/weapons/player/wpn_packmaster_claw_combo/wpn_packmaster_claw_combo"
	}
}

return {
	packmaster_claw = table.clone(tbl)
}
