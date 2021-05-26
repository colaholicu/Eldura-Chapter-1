#include "e_debug_out"

void main()
{
    string target = GetLocalString(OBJECT_SELF, "Target");
    object waypoint = GetWaypointByTag(target);

    AssignCommand(GetLastUsedBy(), ClearAllActions());
    AssignCommand(GetLastUsedBy(), JumpToObject(waypoint));
}
