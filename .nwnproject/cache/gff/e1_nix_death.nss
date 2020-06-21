//::///////////////////////////////////////////////////
//:: X0_C2_DTH_LOOT
//:: OnDeath handler.
//:: Leave a lootable corpse that will never decay.
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/07/2002
//::///////////////////////////////////////////////////

#include "nw_i0_generic"
#include "x0_i0_corpses"
object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_IS_PC);
void main()
{
    AssignCommand(oPC,SpeakString("As Nix dies you cut yourself in her dagger, you feel a strange feeling and collapse"));
    ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDamage(1,DAMAGE_TYPE_SLASHING,DAMAGE_POWER_NORMAL),oPC);
    DelayCommand(2.0,AssignCommand(oPC,PlayAnimation(ANIMATION_LOOPING_DEAD_FRONT,2.0,5.0)));
    DelayCommand(2.0,FadeToBlack(oPC,FADE_SPEED_FAST));
    DelayCommand(2.5,AssignCommand(oPC,ActionJumpToObject(GetObjectByTag("wp3"),FALSE)));
    DelayCommand(6.0,FadeFromBlack(oPC,FADE_SPEED_FAST));
    // * make sure this can happen only once.
    if (GetLocalInt(OBJECT_SELF, "NW_L_DEATHEVENTFIRED") == 10) return;
    SetLocalInt(OBJECT_SELF, "NW_L_DEATHEVENTFIRED",10) ;

    int nClass = GetLevelByClass(CLASS_TYPE_COMMONER);
    int nAlign = GetAlignmentGoodEvil(OBJECT_SELF);
    if(nClass > 0 && (nAlign == ALIGNMENT_GOOD || nAlign == ALIGNMENT_NEUTRAL))
    {
        object oKiller = GetLastKiller();
        AdjustAlignment(oKiller, ALIGNMENT_EVIL, 5);
    }

    SpeakString("NW_I_AM_DEAD", TALKVOLUME_SILENT_TALK);

    //Shout Attack my target, only works with the On Spawn In setup
    SpeakString("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK);

    if(GetSpawnInCondition(NW_FLAG_DEATH_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(1007));
    }

    // Leave a lootable corpse that will never decay
    KillAndReplaceLootable(OBJECT_SELF, FALSE, FALSE);
}
