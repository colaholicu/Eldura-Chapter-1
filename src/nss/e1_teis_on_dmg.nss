//:://////////////////////////////////////////////////
//:: NW_C2_DEFAULT6
//:: Default OnDamaged handler
/*
    If already fighting then ignore, else determine
    combat round
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/22/2002
//:://////////////////////////////////////////////////
//:://////////////////////////////////////////////////
//:: Modified By: Deva Winblood
//:: Modified On: Jan 17th, 2008
//:: Added Support for Mounted Combat Feat Support
//:://////////////////////////////////////////////////

#include "nw_i0_generic"
#include "x3_inc_horse"

void main()
{
    object oDamager = GetLastDamager();
    object oMe=OBJECT_SELF;
    int nHPBefore;
    if (!GetLocalInt(GetModule(),"X3_NO_MOUNTED_COMBAT_FEAT"))
    if (GetHasFeat(FEAT_MOUNTED_COMBAT)&&HorseGetIsMounted(OBJECT_SELF))
    { // see if can negate some damage
        if (GetLocalInt(OBJECT_SELF,"bX3_LAST_ATTACK_PHYSICAL"))
        { // last attack was physical
            nHPBefore=GetLocalInt(OBJECT_SELF,"nX3_HP_BEFORE");
            if (!GetLocalInt(OBJECT_SELF,"bX3_ALREADY_MOUNTED_COMBAT"))
            { // haven't already had a chance to use this for the round
                SetLocalInt(OBJECT_SELF,"bX3_ALREADY_MOUNTED_COMBAT",TRUE);
                int nAttackRoll=GetBaseAttackBonus(oDamager)+d20();
                int nRideCheck=GetSkillRank(SKILL_RIDE,OBJECT_SELF)+d20();
                if (nRideCheck>=nAttackRoll&&!GetIsDead(OBJECT_SELF))
                { // averted attack
                    if (GetIsPC(oDamager)) SendMessageToPC(oDamager,GetName(OBJECT_SELF)+GetStringByStrRef(111991));
                    //if (GetIsPC(OBJECT_SELF)) SendMessageToPCByStrRef(OBJECT_SELF,111992");
                    if (GetCurrentHitPoints(OBJECT_SELF)<nHPBefore)
                    { // heal
                        effect eHeal=EffectHeal(nHPBefore-GetCurrentHitPoints(OBJECT_SELF));
                        AssignCommand(GetModule(),ApplyEffectToObject(DURATION_TYPE_INSTANT,eHeal,oMe));
                    } // heal
                } // averted attack
            } // haven't already had a chance to use this for the round
        } // last attack was physical
    } // see if can negate some damage
    if(GetFleeToExit()) {
        // We're supposed to run away, do nothing
    } else if (GetSpawnInCondition(NW_FLAG_SET_WARNINGS)) {
        // don't do anything?
    } else {
        if (!GetIsObjectValid(oDamager)) {
            // don't do anything, we don't have a valid damager
        } else if (!GetIsFighting(OBJECT_SELF)) {
            // If we're not fighting, determine combat round
            if(GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL)) {
                DetermineSpecialBehavior(oDamager);
            } else {
                if(!GetObjectSeen(oDamager)
                   && GetArea(OBJECT_SELF) == GetArea(oDamager)) {
                    // We don't see our attacker, go find them
                    ActionMoveToLocation(GetLocation(oDamager), TRUE);
                    ActionDoCommand(DetermineCombatRound());
                } else {
                    DetermineCombatRound();
                }
            }
        } else {
            // We are fighting already -- consider switching if we've been
            // attacked by a more powerful enemy
            object oTarget = GetAttackTarget();
            if (!GetIsObjectValid(oTarget))
                oTarget = GetAttemptedAttackTarget();
            if (!GetIsObjectValid(oTarget))
                oTarget = GetAttemptedSpellTarget();

            // If our target isn't valid
            // or our damager has just dealt us 25% or more
            //    of our hp in damager
            // or our damager is more than 2HD more powerful than our target
            // switch to attack the damager.
            if (!GetIsObjectValid(oTarget)
                || (
                    oTarget != oDamager
                    &&  (
                         GetTotalDamageDealt() > (GetMaxHitPoints(OBJECT_SELF) / 4)
                         || (GetHitDice(oDamager) - 2) > GetHitDice(oTarget)
                         )
                    )
                )
            {
                // Switch targets
                DetermineCombatRound(oDamager);
            }
        }
    }

    if (!GetLocalInt(OBJECT_SELF, "StoppedCombat") && (GetCurrentHitPoints(OBJECT_SELF) <= FloatToInt((GetMaxHitPoints() * 0.1f))))
    {
        object pc = GetFirstPC();
        ClearAllActions(TRUE);
        AssignCommand(pc, ClearAllActions(TRUE));

        // Find all the faction members of the summoner (the summoned creatures)
        object oCreature = GetFirstFactionMember(pc);
        while (GetIsObjectValid(oCreature))
        {
            // Do something with the summoned creature, like storing its pointer or applying commands
            // For example, you could store the object pointer in a local variable
            object oSummonedCreature = oCreature;

            // Do something with oSummonedCreature, e.g., assign a command to it
            AssignCommand(oSummonedCreature, ClearAllActions(TRUE));
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), GetLocation(oSummonedCreature));
            DestroyObject(oSummonedCreature);

            // Move to the next faction member (summoned creature)
            oCreature = GetNextFactionMember(pc);
        }

        SetIsTemporaryFriend(pc);
        SetIsTemporaryFriend(OBJECT_SELF, pc);
        SetLocalInt(OBJECT_SELF, "StoppedCombat", 1);
        AssignCommand(OBJECT_SELF, ActionStartConversation(pc, "e1_teis_mor_tk", FALSE, FALSE));
    }

    // Send the user-defined event signal
    if(GetSpawnInCondition(NW_FLAG_DAMAGED_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_DAMAGED));
    }
}
