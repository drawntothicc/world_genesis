/obj/machinery/advplantgenes
	name = "advanced plant gene editor"
	desc = "A more advanced gene editor, focused on precise modification of existing genes."
	icon = 'GainStation13/icons/obj/hydroponics/advplantgenes.dmi'
	icon_state = "functional"
	density = TRUE
	circuit = /obj/item/circuitboard/machine/advplantgenes

var/obj/item/seeds/seed
var/obj/item/disk/plantgene/disk

var/datum/plant_gene/target
var/operation = ""

var/list/reagent_genes = list()

//Updates the gene list.
/obj/machinery/advplantgenes/proc/update_genes()
	reagent_genes = list()
	update_icon() // fuck it any time a disk enters or leaves the machine update_genes() gets called so i might as well do it here

//Ejects the disk.
/obj/machinery/advplantgenes/proc/adv_eject_disk()
	if (disk && !operation)
		if(Adjacent(usr) && !issilicon(usr))
			if (!usr.put_in_hands(disk))
				disk.forceMove(drop_location())
		else
			disk.forceMove(drop_location())
		disk = null
		update_genes()

//Increases the gene rate (percentage) [ie Nutriment production X%]
/obj/machinery/advplantgenes/proc/increase_gene_rate(var/datum/plant_gene/G)
	var/datum/plant_gene/reagent/G_INC = G.Copy()
	if (G_INC.rate >= 0.2)
		return
	G_INC.rate += 0.01
	disk.gene = G_INC
	disk.update_name()
	return

//Decreases the gene rate.
/obj/machinery/advplantgenes/proc/decrease_gene_rate(var/datum/plant_gene/G)
	var/datum/plant_gene/reagent/G_DEC = G.Copy()
	if (G_DEC.rate >= 0.02)
		G_DEC.rate -= 0.01
		disk.gene = G_DEC
		disk.update_name()
	return

//Handles cases where a seed or plant disk is used directly on the machine.
/obj/machinery/advplantgenes/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction_screwdriver(user, "functional", "functional", I))
		update_icon()
		return
	else if(default_unfasten_wrench(user, I))
		return
	if(default_deconstruction_crowbar(I))
		return
	if(iscyborg(user))
		return

	if(istype(I, /obj/item/seeds))
		if(seed)
			to_chat(user, "<span class='notice'>The machine is only built to modify disks.</span>")
		return
	else if(istype(I, /obj/item/disk/plantgene))
		if (operation)
			to_chat(user, "<span class='notice'>Please complete current operation.</span>")
			return
		adv_eject_disk()
		if(!user.transferItemToLoc(I, src))
			return
		disk = I
		to_chat(user, "<span class='notice'>You add [I] to the machine.</span>")
		update_icon()
		interact(user)
	else
		..()

//Handles direct interaction.
/obj/machinery/advplantgenes/ui_interact(mob/user)
	. = ..()
	if(!user)
		return

	var/datum/browser/popup = new(user, "advplantdna", "Advanced Plant Gene Editor", 450, 600)
	if(!(in_range(src, user) || hasSiliconAccessInArea(user)))
		popup.close()
		return

	var/dat = ""

	if(operation)
		if(!disk)
			operation = ""
			target = null
			interact(user)
			return
		if((operation == "increase" || operation == "decrease"))
			operation = ""
			target = null
			interact(user)
			return
		popup.set_content(dat)
		popup.open()
		return

	dat += "<div class='statusDisplay'>"
	dat += "<div class='line'><div class='statusLabel'>Data Disk:</div><div class='statusValue'><a href='?src=[REF(src)];adv_eject_disk=1'>"
	if(!disk)
		dat += "None"
	else if(!disk.gene)
		dat += "Empty Disk"
	else
		dat += disk.gene.get_name()
	if(disk && disk.read_only)
		dat += " (RO)"
	dat += "</a></div></div>"

	if(disk)
		dat += "<div class='line'><h3>Current Gene</h3></div><div class='statusDisplay'>"
		if(disk.gene)
			dat += "<table>"
			dat += "<tr><td width='260px'>[disk.gene.get_name()]</td><td>"
			dat += "<a href='?src=[REF(src)];gene=[REF(disk.gene)];op=increase'>Increase</a>"
			dat += "<a href='?src=[REF(src)];gene=[REF(disk.gene)];op=decrease'>Decrease</a>"
			dat += "</td></tr>"
			dat += "</table>"
			dat += "</div>"
		else
			dat += "No content-related genes detected in sample.<br>"
			dat += "</div>"
	dat += "<br></div>"
	popup.set_content(dat)
	popup.open()

//idrk know what ts does exactly but it works
//my best guess is that it runs a series of checks after an interaction is complete, checking to see what was pressed and running methods after
/obj/machinery/advplantgenes/Topic(var/href, var/list/href_list)
	if(..())
		return
	usr.set_machine(src)

	if(href_list["adv_eject_disk"] && !operation)
		var/obj/item/I = usr.get_active_held_item()
		adv_eject_disk()
		if(istype(I, /obj/item/disk/plantgene))
			if(!usr.transferItemToLoc(I, src))
				return
			disk = I
			to_chat(usr, "<span class='notice'>You add [I] to the machine.</span>")

	else if(href_list["op"] == "increase" && disk && disk.gene)
		operation = "increase"
		increase_gene_rate(disk.gene)
		update_genes()
		operation = ""
		target = null

	else if(href_list["op"] == "decrease" && disk && disk.gene)
		operation = "decrease"
		decrease_gene_rate(disk.gene)
		update_genes()
		operation = ""
		target = null
	interact(usr)

// Circuit Board
/obj/item/circuitboard/machine/advplantgenes
	name = "Advanced Plant Gene Editor (Machine Board)"
	icon_state = "service"
	build_path = /obj/machinery/advplantgenes
	req_components = list(
		/obj/item/stock_parts/manipulator = 3,
		/obj/item/stock_parts/micro_laser = 3,
		/obj/item/stack/sheet/glass = 2,
		/obj/item/stock_parts/scanning_module = 2)

// Sprite Changes

/obj/machinery/advplantgenes/update_icon_state()
	if((machine_stat & (BROKEN|NOPOWER)))
		icon_state = "non-functional"
	else
		icon_state = "functional"

/obj/machinery/advplantgenes/update_overlays()
	. = ..()
	if(disk)
		. += "plant-disk"
	if(panel_open)
		. += "panel-open"
