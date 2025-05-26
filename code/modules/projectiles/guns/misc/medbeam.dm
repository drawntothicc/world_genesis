/obj/item/gun/medbeam
	name = "Medical Beamgun"
	desc = "Don't cross the streams!"
	icon = 'icons/obj/chronos.dmi'
	icon_state = "chronogun"
	item_state = "chronogun"
	w_class = WEIGHT_CLASS_NORMAL

	var/mob/living/current_target
	var/last_check = 0
	var/check_delay = 10 //Check los as often as possible, max resolution is SSobj tick though
	var/max_range = 8
	var/active = 0
	var/datum/beam/current_beam = null
	var/mounted = 0 //Denotes if this is a handheld or mounted version

	weapon_weight = WEAPON_MEDIUM

/obj/item/gun/medbeam/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/gun/medbeam/Destroy(mob/user)
	STOP_PROCESSING(SSobj, src)
	LoseTarget()
	return ..()

/obj/item/gun/medbeam/dropped(mob/user)
	..()
	LoseTarget()

/obj/item/gun/medbeam/equipped(mob/user)
	..()
	LoseTarget()

/obj/item/gun/medbeam/proc/LoseTarget()
	if(active)
		qdel(current_beam)
		current_beam = null
		active = 0
		on_beam_release(current_target)
	current_target = null

/obj/item/gun/medbeam/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0, stam_cost = 0)
	if(isliving(user))
		add_fingerprint(user)

	if(current_target)
		LoseTarget()
	if(!isliving(target) || (user == target))
		return

	current_target = target
	active = TRUE
	current_beam = new(user,current_target,time=6000,beam_icon_state="medbeam",btype=/obj/effect/ebeam/medical)
	INVOKE_ASYNC(current_beam, TYPE_PROC_REF(/datum/beam, Start))

	SSblackbox.record_feedback("tally", "gun_fired", 1, type)

/obj/item/gun/medbeam/process()

	var/source = loc
	if(!mounted && !isliving(source))
		LoseTarget()
		return

	if(!current_target)
		LoseTarget()
		return

	if(world.time <= last_check+check_delay)
		return

	last_check = world.time

	if(get_dist(source, current_target)>max_range || !los_check(source, current_target))
		LoseTarget()
		if(isliving(source))
			to_chat(source, "<span class='warning'>You lose control of the beam!</span>")
		return

	if(current_target)
		on_beam_tick(current_target)

/obj/item/gun/medbeam/proc/los_check(atom/movable/user, mob/target)
	var/turf/user_turf = user.loc
	if(mounted)
		user_turf = get_turf(user)
	else if(!istype(user_turf))
		return FALSE
	var/obj/dummy = new(user_turf)
	dummy.pass_flags |= PASSTABLE|PASSGLASS|PASSGRILLE //Grille/Glass so it can be used through common windows
	for(var/turf/turf in getline(user_turf,target))
		if(mounted && turf == user_turf)
			continue //Mechs are dense and thus fail the check
		if(turf.density)
			qdel(dummy)
			return FALSE
		for(var/atom/movable/AM in turf)
			if(!AM.CanPass(dummy,turf,1))
				qdel(dummy)
				return FALSE
		for(var/obj/effect/ebeam/medical/B in turf)// Don't cross the str-beams!
			if(B.owner.origin != current_beam.origin)
				explosion(B.loc,0,3,5,8)
				qdel(dummy)
				return FALSE
	qdel(dummy)
	return TRUE

/obj/item/gun/medbeam/proc/on_beam_hit(var/mob/living/target)
	return

/obj/item/gun/medbeam/proc/on_beam_tick(var/mob/living/target)
	if(target.health != target.maxHealth)
		new /obj/effect/temp_visual/heal(get_turf(target), "#80F5FF")
	target.adjustBruteLoss(-4)
	target.adjustFireLoss(-4)
	target.adjustToxLoss(-1, forced = TRUE)
	target.adjustOxyLoss(-1)
	return

/obj/item/gun/medbeam/proc/on_beam_release(var/mob/living/target)
	return

/obj/effect/ebeam/medical
	name = "medical beam"

//////////////////////////////Mech Version///////////////////////////////
/obj/item/gun/medbeam/mech
	mounted = 1

/obj/item/gun/medbeam/mech/Initialize(mapload)
	. = ..()
	STOP_PROCESSING(SSobj, src) //Mech mediguns do not process until installed, and are controlled by the holder obj


//////////////////////Caloray///////////////////////////////////////////

/obj/item/gun/caloray
	name = "Caloray"
	desc = "A device that uses gainium shards to siphon calories from organic beings. It is currently set to fatten."
	icon = 'icons/obj/chronos.dmi'
	icon_state = "caloray_push"
	item_state = "chronogun"
	w_class = WEIGHT_CLASS_NORMAL

	var/mob/living/current_target
	var/last_check = 0
	var/check_delay = 10 //Check los as often as possible, max resolution is SSobj tick though
	var/max_range = 8
	var/active = 0
	var/datum/beam/current_beam = null
	var/mounted = 0 //Denotes if this is a handheld or mounted version
	var/mode = "fatten"
	var/powerbeam = "sm_arc_dbz_referance"
	var/calgen = 0
	var/opened = FALSE
	var/intensity = 10

	var/cell_type = /obj/item/stock_parts/cell/high
	var/obj/item/stock_parts/cell/cell

	weapon_weight = WEAPON_MEDIUM

/obj/item/gun/caloray/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)
	if(!cell && cell_type)
		cell = new cell_type
		cell.charge = 0

/obj/item/gun/caloray/Destroy(mob/user)
	STOP_PROCESSING(SSobj, src)
	LoseTarget()
	return ..()

/obj/item/gun/caloray/dropped(mob/user)
	..()
	LoseTarget()

/obj/item/gun/caloray/attack_self(mob/user)
	if(opened == FALSE && cell)
		if (mode == "fatten")
			to_chat(user, "<span class='notice'>You change the setting on the beam to thin.</span>")
			powerbeam = "sm_arc_supercharged"
			mode = "thin"
			desc = "A device that uses gainium shards to siphon calories from organic beings. It is currently set to [mode] at [intensity*2]% intensity, and it's cell is [(cell.charge/cell.maxcharge)*100]% charged."
			icon_state = "caloray_pull"
			playsound(user, 'sound/weapons/gun_slide_lock_1.ogg', 60, 1)
			LoseTarget()
		else
			to_chat(user, "<span class='notice'>You change the setting on the beam to fatten.</span>")
			powerbeam = "sm_arc_dbz_referance"
			mode = "fatten"
			desc = "A device that uses gainium shards to siphon calories from organic beings. It is currently set to [mode] at [intensity*2]% intensity, and it's cell is [(cell.charge/cell.maxcharge)*100]% charged."
			icon_state = "caloray_push"
			playsound(user, 'sound/weapons/gun_slide_lock_1.ogg', 60, 1)
			LoseTarget()

	if(opened == TRUE && cell)
		user.visible_message("[user] removes [cell] from [src]!","<span class='notice'>You remove [cell].</span>")
		cell.update_icon()
		user.put_in_hands(cell)
		cell = null
		desc = "A device that uses gainium shards to siphon calories from organic beings. It currently has no power cell and cannot function."
		icon_state = "caloray_off"
		playsound(user, 'sound/weapons/ionpulse.ogg', 60, 1)
		update_icon()
		LoseTarget()
		return

	if(opened == TRUE && cell == null)
		user.visible_message("<span class='warning'>The Caloray doesn't have a power cell installed.</span>")
		desc = "A device that uses gainium shards to siphon calories from organic beings. It currently has no power cell and cannot function."
		icon_state = "caloray_off"
		LoseTarget()
		return



/obj/item/gun/caloray/attackby(obj/item/W, mob/user)
	if(W.tool_behaviour == TOOL_WRENCH)
		if(opened == FALSE)
			W.play_tool_sound(src)
			to_chat(user, "<span class='notice'>You open the Caloray's battery compartment.</span>")
			desc = "A device that uses gainium shards to siphon calories from organic beings. It is currently set to [mode] at [intensity*2]% intensity, and it's cell is [(cell.charge/cell.maxcharge)*100]% charged. It's battery compartment is currently open."
			opened = TRUE
			LoseTarget()
			return

		if(opened == TRUE)
			W.play_tool_sound(src)
			to_chat(user, "<span class='notice'>You close the Caloray's battery compartment.</span>")
			desc = "A device that uses gainium shards to siphon calories from organic beings. It is currently switched off and has no power cell inserted."
			opened = FALSE
			LoseTarget()
			return


	if(istype(W, /obj/item/stock_parts/cell))
		if(opened)
			if(!cell)
				if(!user.transferItemToLoc(W, src))
					return
				to_chat(user, "<span class='notice'>You insert [W] into [src].</span>")
				cell = W
				update_icon()
				if(mode == "fatten")
					powerbeam = "sm_arc_dbz_referance"
					icon_state = "caloray_push"
					desc = desc = "A device that uses gainium shards to siphon calories from organic beings. It is currently set to [mode] at [intensity*2]% intensity, and it's cell is [(cell.charge/cell.maxcharge)*100]% charged. It's battery compartment is currently open."
				if(mode == "thin")
					powerbeam = "sm_arc_supercharged"
					icon_state = "caloray_pull"
					desc = desc = "A device that uses gainium shards to siphon calories from organic beings. It is currently set to [mode] at [intensity*2]% intensity, and it's cell is [(cell.charge/cell.maxcharge)*100]% charged. It's battery compartment is currently open."
				return
			else
				to_chat(user, "<span class='notice'>[src] already has \a [cell] installed!</span>")
				return

	if(W.tool_behaviour == TOOL_MULTITOOL)
		if(intensity < 50)
			intensity += 10
		else
			intensity = 10
		W.play_tool_sound(src)
		to_chat(user, "<span class='notice'>You set the Caloray's beam intensity to [intensity*2]%.</span>")





/obj/item/gun/caloray/equipped(mob/user)
	..()
	LoseTarget()

/obj/item/gun/caloray/proc/LoseTarget()
	if(active)
		qdel(current_beam)
		current_beam = null
		active = 0
		on_beam_release(current_target)
	current_target = null

/obj/item/gun/caloray/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0, stam_cost = 0)
	if(cell)
		if(isliving(user))
			add_fingerprint(user)

		if(current_target)
			LoseTarget()
		if(!isliving(target) || (user == target))
			return

		current_target = target
		active = TRUE
		current_beam = new(user,current_target,time=6000,beam_icon_state=powerbeam,btype=/obj/effect/ebeam/medical)
		playsound(user, 'sound/weapons/caloray.ogg', 60, 1)
		INVOKE_ASYNC(current_beam, TYPE_PROC_REF(/datum/beam, Start))

		SSblackbox.record_feedback("tally", "gun_fired", 1, type)

/obj/item/gun/caloray/process()

	var/source = loc
	if(!mounted && !isliving(source))
		LoseTarget()
		return

	if(!current_target)
		LoseTarget()
		return

	if(world.time <= last_check+check_delay)
		return

	last_check = world.time

	if(get_dist(source, current_target)>max_range || !los_check(source, current_target))
		LoseTarget()
		if(isliving(source))
			to_chat(source, "<span class='warning'>You lose control of the beam!</span>")
			playsound(source, 'sound/weapons/ionpulse.ogg', 60, 1)
		return

	if(current_target)
		on_beam_tick(current_target)

/obj/item/gun/caloray/proc/los_check(atom/movable/user, mob/target)
	var/turf/user_turf = user.loc
	if(mounted)
		user_turf = get_turf(user)
	else if(!istype(user_turf))
		return FALSE
	var/obj/dummy = new(user_turf)
	dummy.pass_flags |= PASSTABLE|PASSGLASS|PASSGRILLE //Grille/Glass so it can be used through common windows
	for(var/turf/turf in getline(user_turf,target))
		if(mounted && turf == user_turf)
			continue //Mechs are dense and thus fail the check
		if(turf.density)
			qdel(dummy)
			return FALSE
		for(var/atom/movable/AM in turf)
			if(!AM.CanPass(dummy,turf,1))
				qdel(dummy)
				return FALSE
		for(var/obj/effect/ebeam/medical/B in turf)// Don't cross the str-beams!
			if(B.owner.origin != current_beam.origin)
				explosion(B.loc,0,3,5,8)
				qdel(dummy)
				return FALSE
	qdel(dummy)
	return TRUE

/obj/item/gun/caloray/proc/on_beam_hit(var/mob/living/target)
	return

/obj/item/gun/caloray/proc/on_beam_tick(var/mob/living/carbon/target)
	if(target.fatness > 0)
		if(mode == "thin")
			new /obj/effect/temp_visual/heal(get_turf(target), "#1100ff")
			target.adjust_fatness(-intensity)
			cell.charge += ((cell.maxcharge*0.05) + intensity)
	if(target.fatness >= 0)
		if(mode == "fatten")
			if(cell.charge > 0)
				new /obj/effect/temp_visual/heal(get_turf(target), "#ff0000")
				target.adjust_fatness(intensity)
				cell.charge -= ((cell.maxcharge*0.05) + intensity)
	if(target.fatness <= 0)
		if(mode == "thin")
			LoseTarget()
			return
	if(cell.charge <= 0)
		if(mode == "fatten")
			LoseTarget()
			return
	if(cell.charge == cell.maxcharge)
		if(mode == "thin")
			LoseTarget()
			return
	desc = "A device that uses gainium shards to siphon calories from organic beings. It is currently set to [mode] at [intensity*2]% intensity, and it's cell is [(cell.charge/cell.maxcharge)*100]% charged. It's battery compartment is currently open."
	return

/obj/item/gun/caloray/proc/on_beam_release(var/mob/living/target)
	return

/obj/effect/ebeam/medical
	name = "medical beam"


//////////////////////////////Mech Version///////////////////////////////
/obj/item/gun/caloray/mech
	mounted = 1

/obj/item/gun/caloray/mech/Initialize(mapload)
	. = ..()
	STOP_PROCESSING(SSobj, src) //Mech mediguns do not process until installed, and are controlled by the holder obj

