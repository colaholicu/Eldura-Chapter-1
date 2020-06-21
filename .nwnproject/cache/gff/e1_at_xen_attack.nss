#include "nw_i0_generic"

void main()
{
    object pc = GetFirstPC();
    object xen = GetNearestObjectByTag("e1_vidma", pc);
    object arcanys = GetNearestObjectByTag("e1_arcanys", pc);

    SetIsTemporaryEnemy(arcanys, xen);

    AssignCommand(xen, ClearAllActions());

    // SetCutsceneMode(pc);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAttackIncrease(400, ATTACK_BONUS_ONHAND), xen);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAttackIncrease(400, ATTACK_BONUS_OFFHAND), xen);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectACDecrease(20, AC_DODGE_BONUS), arcanys, 180.0f);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectACDecrease(20, AC_NATURAL_BONUS), arcanys, 180.0f);
    SetPlotFlag(arcanys, TRUE);

    AssignCommand(xen, ActionAttack(arcanys));

    DelayCommand(0.5f, SetIsTemporaryFriend(arcanys, xen));
    DelayCommand(0.5f, SetIsTemporaryFriend(xen, arcanys));
    DelayCommand(0.5f, AssignCommand(xen, ClearAllActions()));
    DelayCommand(0.75f, AssignCommand(arcanys, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0f, 2000.0f)));
    DelayCommand(1.0f, SetLocalInt(arcanys, "IsFakeDead", 1));
    DelayCommand(1.5f, AssignCommand(xen, ActionStartConversation(GetFirstPC(), "e1_at_xen_tk", FALSE, FALSE)));
}
