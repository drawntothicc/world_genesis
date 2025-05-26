
//////////////////////Caloray///////////////////////////////////////////

/obj/item/gun/caloray
	name = "Caloray"
	desc = "A device that uses gainium shards to siphon calories from organic beings. It is currently set to fatten."
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
	var/polarity = 10
	var/powerbeam = "sm_arc_supercharged"

	weapon_weight = WEAPON_MEDIUM

/obj/item/gun/caloray/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/gun/caloray/Destroy(mob/user)
	STOP_PROCESSING(SSobj, src)
	LoseTarget()
	return ..()

/obj/item/gun/caloray/dropped(mob/user)
	..()
	LoseTarget()

/obj/item/gun/caloray/attack_self(mob/user)
	if (polarity == 10)
		to_chat(user, "<span class='notice'>You change the setting on the beam to thin.</span>")
		polarity = -10
		powerbeam = "sm_arc_supercharged"
		desc = "A device that uses gainium shards to siphon calories from organic beings. It is currently set to thin."
		LoseTarget()
	else
		to_chat(user, "<span class='notice'>You change the setting on the beam to fatten.</span>")
		polarity = 10
		powerbeam = "sm_arc_dbz_referance"
		desc = "A device that uses gainium shards to siphon calories from organic beings. It is currently set to fatten."
		LoseTarget()

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
	if(isliving(user))
		add_fingerprint(user)

	if(current_target)
		LoseTarget()
	if(!isliving(target) || (user == target))
		return

	current_target = target
	active = TRUE
	current_beam = new(user,current_target,time=6000,beam_icon_state=powerbeam,btype=/obj/effect/ebeam/medical)
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
	if(target.health != target.maxHealth)
		new /obj/effect/temp_visual/heal(get_turf(target), "#d9ff00")
	target.adjust_fatness(polarity)
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



//////////////////////Caloray///////////////////////////////////////////

/obj/item/gun/caloray
	name = "Caloray"
	desc = "A device that uses gainium shards to siphon calories from organic beings. It is currently set to fatten. It currently has 0 kcals of energy stored."
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
	var/mode = "fatten"
	var/polarity = 10
	var/powerbeam = "sm_arc_supercharged"
	var/calgen = 0

	var/opened = FALSE
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
	if (polarity == 10)
		to_chat(user, "<span class='notice'>You change the setting on the beam to thin.</span>")
		polarity = -10
		powerbeam = "sm_arc_supercharged"
		mode = "thin"
		desc = "A device that uses gainium shards to siphon calories from organic beings, It is currently set to [mode]. It currently has [cell.charge] kcals of energy stored."
		LoseTarget()
	else
		to_chat(user, "<span class='notice'>You change the setting on the beam to fatten.</span>")
		polarity = 10
		powerbeam = "sm_arc_dbz_referance"
		mode = "fatten"
		desc = "A device that uses gainium shards to siphon calories from organic beings, It is currently set to [mode]. It currently has [cell.charge] kcals of energy stored."
		LoseTarget()

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
	if(isliving(user))
		add_fingerprint(user)

	if(current_target)
		LoseTarget()
	if(!isliving(target) || (user == target))
		return

	current_target = target
	active = TRUE
	current_beam = new(user,current_target,time=6000,beam_icon_state=powerbeam,btype=/obj/effect/ebeam/medical)
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
	if(target.fatness != target.maxHealth)
		new /obj/effect/temp_visual/heal(get_turf(target), "#d9ff00")
	target.adjust_fatness(polarity)
	cell.charge -= polarity
	desc = "A device that uses gainium shards to siphon calories from organic beings, It is currently set to [mode]. It currently has [cell.charge] kcals of energy stored."
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



