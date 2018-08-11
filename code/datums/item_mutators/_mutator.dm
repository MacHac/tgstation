#define MUTATOR_FREQUENCY_COMMON 3
#define MUTATOR_FREQUENCY_RARE 1
#define MUTATOR_FREQUENCY_NEVER 0 //badmin only

#define MUTATOR_REVEAL_ALWAYS 100       //100% chance to reveal
#define MUTATOR_REVEAL_NEVER 0          //Never reveals
#define MUTATOR_REVEAL_ALMOST_NEVER 1   //1% chance to reveal
#define MUTATOR_REVEAL_SOMETIMES 25     //25% chance to reveal
#define MUTATOR_REVEAL_USUALLY 75       //75% chance to reveal

/datum/mutator
    var/name = "no-op mutator"
    var/desc = "-5 to functionality, +3 to bad coding.  File a bug report if you see this."
    var/list/subtype_blacklist = list() //This mutator should not be applied to these subtypes
    var/list/subtype_whitelist = list() //This mutator can ONLY be applied to these subtypes

    var/frequency = MUTATOR_FREQUENCY_NEVER //The odds that this mutator is randomly picked
    var/reveal_prob = MUTATOR_REVEAL_ALWAYS //The odds that this mutator is revealed

//Checks
//Is mutator valid for an object?
/datum/mutator/proc/IsValid(parent)
    return istype(parent, /obj/item)

//Events
//Called when the mutator is first added
/datum/mutator/proc/Init(parent)
    parent.name = "-5 [parent.name] of brokenness"
    return

//Parent was used in hand by user
/datum/mutator/proc/UsedInHand(parent, mob/user)
    return TRUE //return false to abort normal attack-self functionality

//User attacked target with parent in melee (not ranged)
/datum/mutator/proc/PreMeleeAttack(parent, atom/target, mob/user, params)
    return TRUE //return false to prevent an attack

//User attacked target with parent (in ranged or melee)
/datum/mutator/proc/AfterAttack(parent, atom/target, mob/user, params)
    return

//When hit by an EMP
/datum/mutator/proc/EmpAct(parent, severity)
    return

//When exposed to fire
/datum/mutator/proc/FireAct(parent, temperature, volume)
    return

//User is about to fire parent
/datum/mutator/proc/GunCanFire(parent, mob/user)
    return TRUE //return false to abort the firing

//Projectile fired by parent is hitting target
/datum/mutator/proc/ProjectileImpact(parent, atom/target, blocked)
    return TRUE //return false to prevent the bullet from having its normal effect