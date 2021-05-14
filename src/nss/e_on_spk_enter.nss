#include "e_debug_out"

void main()
{
    object target = GetNearestObjectByTag(GetLocalString(OBJECT_SELF, "target"));
    string line = GetLocalString(OBJECT_SELF, "line");

    if (target == OBJECT_INVALID || GetStringLength(line) <= 0)
    {
        DebugOut("Trigger with tag " + GetTag(OBJECT_SELF) + "needs to have valied values configured on the object for the \'target\' and \'line\' variables");
        DestroyObject(OBJECT_SELF);
        return;
    }

    AssignCommand(target, SpeakString(line));
    DestroyObject(OBJECT_SELF, 0.25f);
}
