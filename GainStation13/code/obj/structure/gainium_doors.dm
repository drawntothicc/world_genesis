/obj/structure/mineral_door/gainium //GS13
	name = "gainium door"
	icon = 'GainStation13/icons/obj/structure/gainium_door.dmi'
	icon_state = "gainium"
	sheetType = /obj/item/stack/sheet/mineral/gainium
	max_integrity = 200
	light_range = 1
	// Sets it open by default
	state = TRUE
	density = FALSE

// If you ever want to make any door like this, just simply add the component like this :3
/obj/structure/mineral_door/gainium/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/fattening_door)

	update_icon() // Updates the sprite when spawned in cause it's closed by default.

