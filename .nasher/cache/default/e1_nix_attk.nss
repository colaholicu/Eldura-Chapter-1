//::///////////////////////////////////////////////
//:: FileName e1_nix_attk
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 1/28/05 8:57:30 PM
//:://////////////////////////////////////////////
#include "nw_i0_generic"

void main()
{

    // Set the faction to hate the player, then attack the player
    SetIsTemporaryEnemy(GetPCSpeaker(),OBJECT_SELF,FALSE);;
    DetermineCombatRound(GetPCSpeaker());
}
