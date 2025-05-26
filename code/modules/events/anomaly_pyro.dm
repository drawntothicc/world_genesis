/datum/round_event_control/anomaly/anomaly_pyro
	name = "Anomaly: Pyroclastic"
	typepath = /datum/round_event/anomaly/anomaly_pyro

	min_players = 10 //GS13 Edit: tweak
	max_occurrences = 0 //GS13 Edit: Disabling this for now.
	weight = 20
	description = "This anomaly sets things on fire, and creates a pyroclastic slime."

/datum/round_event/anomaly/anomaly_pyro
	start_when = 3
	announce_when = 10
	anomaly_path = /obj/effect/anomaly/pyro

/datum/round_event/anomaly/anomaly_pyro/announce(fake)
	priority_announce("Pyroclastic anomaly detected on long range scanners. Expected location: [impact_area.name].", "Anomaly Alert", has_important_message = TRUE)
