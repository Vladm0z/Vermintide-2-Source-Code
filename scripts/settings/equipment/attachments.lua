-- chunkname: @scripts/settings/equipment/attachments.lua

require("scripts/settings/attachment_node_linking")

FirstPersonAttachments = {}
FirstPersonAttachments.witch_hunter = {
	unit = "units/beings/player/witch_hunter/first_person_base/chr_first_person_mesh",
	attachment_node_linking = AttachmentNodeLinking.first_person_attachment
}
FirstPersonAttachments.bright_wizard = {
	unit = "units/beings/player/bright_wizard/first_person_base/chr_first_person_mesh",
	attachment_node_linking = AttachmentNodeLinking.first_person_attachment
}
FirstPersonAttachments.wood_elf = {
	unit = "units/beings/player/way_watcher/first_person_base/chr_first_person_mesh",
	attachment_node_linking = AttachmentNodeLinking.first_person_attachment
}
FirstPersonAttachments.dwarf_ranger = {
	unit = "units/beings/player/dwarf_ranger_upgraded/first_person_base/chr_first_person_mesh",
	attachment_node_linking = AttachmentNodeLinking.first_person_attachment
}
FirstPersonAttachments.empire_soldier = {
	unit = "units/beings/player/empire_soldier/first_person_base/chr_first_person_mesh",
	attachment_node_linking = AttachmentNodeLinking.first_person_attachment
}
Attachments = {}

local tbl = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_trophy",
	attachment_node_linking = AttachmentNodeLinking.trophies.hanging,
	slots = {
		"slot_trinket_1",
		"slot_trinket_2",
		"slot_trinket_3"
	},
	buffs = {}
}
local tbl_2 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_trophy",
	attachment_node_linking = AttachmentNodeLinking.trophies.flat,
	slots = {
		"slot_trinket_1",
		"slot_trinket_2",
		"slot_trinket_3"
	},
	buffs = {}
}

Attachments.hanging_trophy = table.clone(tbl)
Attachments.flat_trophy = table.clone(tbl_2)

local tbl_3 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.wh_hats = table.clone(tbl_3)

local tbl_4 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_wide,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.wh_hats_skinned = table.clone(tbl_4)

local tbl_5 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.wh_face,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.wh_face = table.clone(tbl_5)

local tbl_6 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.wh_face,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_face_00",
		third_person = {
			mtr_head = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_face_00"
		}
	}
}

Attachments.wh_face_no_hair = table.clone(tbl_6)

local tbl_7 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_ears",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.wh_hats_no_ears = table.clone(tbl_7)

local tbl_8 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_ears",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_wide,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.wh_hats_no_ears_skinned = table.clone(tbl_8)

local tbl_9 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_ears_lock_jaw",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_wide,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.wh_hats_no_ears_skinned_lock_jaw = table.clone(tbl_9)

local tbl_10 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_face,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.wh_hats_face_skinned = table.clone(tbl_10)

local tbl_11 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_ears",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_face,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.wh_hats_no_ears_face_skinned = table.clone(tbl_11)

local tbl_12 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_face_00",
		third_person = {
			mtr_head = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_face_00"
		}
	}
}

Attachments.wh_z_hats_tattoo_00 = table.clone(tbl_12)

local tbl_13 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_face,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_face_00",
		third_person = {
			mtr_head = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_face_00"
		}
	}
}

Attachments.wh_z_hats_tattoo_00_face_skinned = table.clone(tbl_13)

local tbl_14 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_face_01",
		third_person = {
			mtr_head = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_face_01"
		}
	}
}

Attachments.wh_z_hats_tattoo_01 = table.clone(tbl_14)

local tbl_15 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_face_02",
		third_person = {
			mtr_head = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_face_02"
		}
	}
}

Attachments.wh_z_hats_tattoo_02 = table.clone(tbl_15)

local tbl_16 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_face_03",
		third_person = {
			mtr_head = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_face_03"
		}
	}
}

Attachments.wh_z_hats_tattoo_03 = table.clone(tbl_16)

local tbl_17 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_face_04",
		third_person = {
			mtr_head = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_face_04"
		}
	}
}

Attachments.wh_z_hats_tattoo_04 = table.clone(tbl_17)

local tbl_18 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_face_05",
		third_person = {
			mtr_head = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_face_05"
		}
	}
}

Attachments.wh_z_hats_tattoo_05 = table.clone(tbl_18)

local tbl_19 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_face_06",
		third_person = {
			mtr_head = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_face_06"
		}
	}
}

Attachments.wh_z_hats_tattoo_06 = table.clone(tbl_19)

local tbl_20 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_hat_10_face",
		third_person = {
			mtr_head = "units/beings/player/witch_hunter_zealot/headpiece/wh_z_hat_10_face"
		}
	}
}

Attachments.wh_z_hat_10 = table.clone(tbl_20)

local tbl_21 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_mask",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_wide,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.ww_hoods = table.clone(tbl_21)

local tbl_22 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_mask",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_face_wide,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.ww_hoods_jaw = table.clone(tbl_22)

local tbl_23 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_balaclava",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_face_wide,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.ww_balaclava_wide = table.clone(tbl_23)

local tbl_24 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_head_default",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_wide,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.ww_full_face = table.clone(tbl_24)

local tbl_25 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_half_mask",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_face_long,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.ww_half_masks = table.clone(tbl_25)

local tbl_26 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_mask",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_face_long,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.ww_masks = table.clone(tbl_26)

local tbl_27 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_head_default",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.ww_hat = table.clone(tbl_27)

local tbl_28 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_head_no_hood",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.ww_hat_no_hood = table.clone(tbl_28)

local tbl_29 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_head_default_no_face",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.ww_hat_no_face = table.clone(tbl_29)

local tbl_30 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_helmet",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.ww_helmet = table.clone(tbl_30)

local tbl_31 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_helmet_ears",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.ww_helmet_ears = table.clone(tbl_31)

local tbl_32 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_helmet_ears",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_face_long,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.ww_helmet_ears_skinned = table.clone(tbl_32)

local tbl_33 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_helmet",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_wide,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.ww_helmet_skinned = table.clone(tbl_33)

local tbl_34 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_helmet_mask",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_face_long,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.ww_helmet_mask = table.clone(tbl_34)

local tbl_35 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_helmet_mask",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_face,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.ww_helmet_mask_jaw = table.clone(tbl_35)

local tbl_36 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_helmet",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_face_long,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.ww_helmet_jaw = table.clone(tbl_36)

local tbl_37 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_head_default",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_face_long,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.ww_half_mask_full_face = table.clone(tbl_37)

local tbl_38 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_eyes_hair_hood_down",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.ww_hide_eyes_hair_hood_down = table.clone(tbl_38)

local tbl_39 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.es_hats = table.clone(tbl_39)

local tbl_40 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_face,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.es_hats_jaw = table.clone(tbl_40)

local tbl_41 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_ears",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.es_hats_no_ear = table.clone(tbl_41)

local tbl_42 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_ears_lock_neck",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.es_hats_no_ear_lock_neck = table.clone(tbl_42)

local tbl_43 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_moustache",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.es_hats_no_moustache = table.clone(tbl_43)

local tbl_44 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_moustache",
	attachment_node_linking = AttachmentNodeLinking.es_hat_skinned_wide,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.es_hats_no_moustache_skinned = table.clone(tbl_44)

local tbl_45 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_ears_moustache",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.es_hats_no_ear_moustache = table.clone(tbl_45)

local tbl_46 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_ears_moustache",
	attachment_node_linking = AttachmentNodeLinking.es_hat_skinned_wide,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.es_hats_no_ear_moustache_skinned = table.clone(tbl_46)

local tbl_47 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_ears_nose_moustache",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.es_hats_no_beard_ear_nose_moustache = table.clone(tbl_47)

local tbl_48 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_beard",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.es_hats_no_beard = table.clone(tbl_48)

local tbl_49 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_ears_beard",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.es_hats_no_ears_beard = table.clone(tbl_49)

local tbl_50 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet_es_hood",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.es_hat_skinned_wide,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.es_hats_skinned = table.clone(tbl_50)

local tbl_51 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet_es_hood",
	show_attachments_event = "lua_hide_ears",
	attachment_node_linking = AttachmentNodeLinking.es_hat_skinned_wide,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.es_hats_no_ears_skinned = table.clone(tbl_51)

local tbl_52 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet_es_hood",
	show_attachments_event = "lua_hide_beard",
	attachment_node_linking = AttachmentNodeLinking.es_hat_skinned_wide,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.es_hats_no_beard_skinned = table.clone(tbl_52)

local tbl_53 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_beard",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.es_beard = table.clone(tbl_53)

local tbl_54 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet_es_hood",
	show_attachments_event = "lua_hide_beard",
	attachment_node_linking = AttachmentNodeLinking.es_beard,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.es_beard_skinned = table.clone(tbl_54)

local tbl_55 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.dr_helmets = table.clone(tbl_55)

local tbl_56 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet_dr_hood",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_wide_arms,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.dr_helmets_skinned_long = table.clone(tbl_56)

local tbl_57 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet_dr_hood",
	show_attachments_event = "lua_hide_head",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_wide_arms,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.dr_helmets_skinned_long_no_head = table.clone(tbl_57)

local tbl_58 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_ears",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.dr_helmets_no_ear = table.clone(tbl_58)

local tbl_59 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_ears",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_face_long,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.dr_helmets_hide_ears_skin_jaw = table.clone(tbl_59)

local tbl_60 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_beard",
	attachment_node_linking = AttachmentNodeLinking.dr_beard,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.dr_helmets_hide_beard = table.clone(tbl_60)

local tbl_61 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_head_beard",
	attachment_node_linking = AttachmentNodeLinking.player_face,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.dr_helmets_hide_head_beard = table.clone(tbl_61)

local tbl_62 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_beard_ears",
	attachment_node_linking = AttachmentNodeLinking.dr_beard,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.dr_helmets_beard_ears = table.clone(tbl_62)

local tbl_63 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_face_show_ears",
	attachment_node_linking = AttachmentNodeLinking.player_face,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.dr_helmets_beard_face = table.clone(tbl_63)

local tbl_64 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_face_hide_ears",
	attachment_node_linking = AttachmentNodeLinking.player_face,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.dr_helmets_beard_face_ears = table.clone(tbl_64)

local tbl_65 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_default_beard_ears",
	attachment_node_linking = AttachmentNodeLinking.dr_beard,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.dr_helmets_hide_beard_ears_default_only = table.clone(tbl_65)

local tbl_66 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_normal_nose",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_00",
		third_person = {
			mtr_face = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_00"
		}
	}
}

Attachments.dr_hair_tattoo_00 = table.clone(tbl_66)

local tbl_67 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_ears",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_face_long,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_00",
		third_person = {
			mtr_face = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_00"
		}
	}
}

Attachments.dr_hair_tattoo_00_hide_ears_skin_jaw = table.clone(tbl_67)

local tbl_68 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_normal_nose",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_01",
		third_person = {
			mtr_face = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_01"
		}
	}
}

Attachments.dr_hair_tattoo_01 = table.clone(tbl_68)

local tbl_69 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_normal_nose",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_02",
		third_person = {
			mtr_face = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_02"
		}
	}
}

Attachments.dr_hair_tattoo_02 = table.clone(tbl_69)

local tbl_70 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_normal_nose",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_03",
		third_person = {
			mtr_face = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_03"
		}
	}
}

Attachments.dr_hair_tattoo_03 = table.clone(tbl_70)

local tbl_71 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_normal_nose",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_04",
		third_person = {
			mtr_face = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_04"
		}
	}
}

Attachments.dr_hair_tattoo_04 = table.clone(tbl_71)

local tbl_72 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_normal_nose",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_05",
		third_person = {
			mtr_face = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_05"
		}
	}
}

Attachments.dr_hair_tattoo_05 = table.clone(tbl_72)

local tbl_73 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_big_nose",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_00",
		third_person = {
			mtr_face = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_00"
		}
	}
}

Attachments.dr_hair_nose_big_tattoo_00 = table.clone(tbl_73)

local tbl_74 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_big_nose",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_01",
		third_person = {
			mtr_face = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_01"
		}
	}
}

Attachments.dr_hair_nose_big_tattoo_01 = table.clone(tbl_74)

local tbl_75 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_big_nose",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_02",
		third_person = {
			mtr_face = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_02"
		}
	}
}

Attachments.dr_hair_nose_big_tattoo_02 = table.clone(tbl_75)

local tbl_76 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_big_nose",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_03",
		third_person = {
			mtr_face = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_03"
		}
	}
}

Attachments.dr_hair_nose_big_tattoo_03 = table.clone(tbl_76)

local tbl_77 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_big_nose",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_04",
		third_person = {
			mtr_face = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_04"
		}
	}
}

Attachments.dr_hair_nose_big_tattoo_04 = table.clone(tbl_77)

local tbl_78 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_big_nose",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_05",
		third_person = {
			mtr_face = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_face_05"
		}
	}
}

Attachments.dr_hair_nose_big_tattoo_05 = table.clone(tbl_78)

local tbl_79 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_normal_nose",
	attachment_node_linking = AttachmentNodeLinking.dr_beard,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_hat_14_face",
		third_person = {
			mtr_face = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_hat_14_face"
		}
	}
}

Attachments.dr_s_hat_14 = table.clone(tbl_79)

local tbl_80 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_beard",
	attachment_node_linking = AttachmentNodeLinking.dr_beard,
	slots = {
		"slot_hat"
	},
	buffs = {},
	character_material_changes = {
		package_name = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_hat_15_face",
		third_person = {
			mtr_face = "units/beings/player/dwarf_ranger_slayer/headpiece/dr_s_hat_15_face"
		}
	}
}

Attachments.dr_s_hat_15 = table.clone(tbl_80)

local tbl_81 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.bw_gate,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.bw_gates = table.clone(tbl_81)

local tbl_82 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears_lock_neck",
	attachment_node_linking = AttachmentNodeLinking.bw_gate,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.bw_gates_lock_neck = table.clone(tbl_82)

local tbl_83 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.bw_hat = table.clone(tbl_83)

local tbl_84 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears_lock_neck",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.bw_hat_lock_neck = table.clone(tbl_84)

local tbl_85 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_hair",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.bw_hat_no_hair = table.clone(tbl_85)

local tbl_86 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_hair",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_wide,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.bw_hat_skinned_wide_no_hair = table.clone(tbl_86)

local tbl_87 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_hair_lock_neck",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.bw_hat_no_hair_lock_neck = table.clone(tbl_87)

local tbl_88 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_hair",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_face,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.bw_hat_jaw_no_hair = table.clone(tbl_88)

local tbl_89 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_ears",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.bw_hat_no_ears = table.clone(tbl_89)

local tbl_90 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_ears_hair",
	attachment_node_linking = AttachmentNodeLinking.hat,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.bw_hat_no_ears_hair = table.clone(tbl_90)

local tbl_91 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.bw_gate_facemask,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.bw_gates_facemask = table.clone(tbl_91)

local tbl_92 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_breastplate",
	attachment_node_linking = AttachmentNodeLinking.bw_gate,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.bw_gates_no_breastplate = table.clone(tbl_92)

local tbl_93 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_breastplate",
	attachment_node_linking = AttachmentNodeLinking.bw_gate_facemask,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.bw_gates_facemask_no_breastplate = table.clone(tbl_93)

local tbl_94 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_wide,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.bw_hat_skinned_wide = table.clone(tbl_94)

local tbl_95 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_face",
	attachment_node_linking = AttachmentNodeLinking.player_face,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.bw_face = table.clone(tbl_95)

local tbl_96 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	link_to_skin = true,
	show_attachments_event = "lua_show_ears",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_cloak,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.bw_hat_cloak = table.clone(tbl_96)

local tbl_97 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet",
	show_attachments_event = "lua_hide_hair",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_hair,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.bw_hair = table.clone(tbl_97)

local tbl_98 = {
	unit = "",
	display_unit = "units/weapons/weapon_display/display_helmet_dr_hood",
	show_attachments_event = "lua_hide_head_eyes",
	attachment_node_linking = AttachmentNodeLinking.hat_skinned_wide_arms,
	slots = {
		"slot_hat"
	},
	buffs = {}
}

Attachments.bw_hat_skinned_wide_no_head = table.clone(tbl_98)

local tbl_99 = {
	display_unit = "",
	attachment_node_linking = AttachmentNodeLinking.non_visual_attachment,
	slots = {
		"slot_necklace"
	}
}

Attachments.necklace_template = table.clone(tbl_99)

local tbl_100 = {
	display_unit = "",
	attachment_node_linking = AttachmentNodeLinking.non_visual_attachment,
	slots = {
		"slot_ring"
	}
}

Attachments.ring_template = table.clone(tbl_100)

local tbl_101 = {
	display_unit = "",
	attachment_node_linking = AttachmentNodeLinking.non_visual_attachment,
	slots = {
		"slot_trinket"
	}
}

Attachments.trinket_template = table.clone(tbl_101)

for k, v in pairs(Attachments) do
	v.name = k

	assert(v.units ~= "", "Name is empty")
	assert(v.attachment_node_linking)
	assert(v.slots)
end
