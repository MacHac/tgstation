//Performs an action when an area is entered.
/datum/component/area_tracker
  var/area/tracked_area

/datum/component/area_tracker/Initialize(area/t_area)
  if(!ismovableatom(parent))
    return COMPONENT_INCOMPATIBLE

  tracked_area = t_area

  RegisterSignal(parent, COMSIG_ENTER_AREA, .proc/new_area_entered)

/datum/component/area_tracker/proc/new_area_entered(area/t_area)
  if(istype(t_area, tracked_area))
    trigger_tracker()

//Override this to suit specific purposes.
/datum/component/area_tracker/proc/trigger_tracker()
  return

/////Specific subclasses\\\\\
//Gives the buyer of a crate notice when it arrives in cargo.
/datum/component/area_tracker/cargo_order_notice/trigger_tracker()
  var/obj/structure/closet/crate/secure/owned/O = parent
  if (!istype(O))
    return
  O.buyer_account.bank_card_talk("An order has been delivered to the station: [O.name]")
  qdel(src)
