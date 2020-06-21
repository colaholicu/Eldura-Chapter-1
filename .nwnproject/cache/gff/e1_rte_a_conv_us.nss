void main()
{
    object sarcophagus = GetNearestObjectByTag("e1_rte_sarcophagus");
    string resref = GetResRef(sarcophagus);
    DestroyObject(sarcophagus, 1.0f);
    object sarcophagusNew = CreateObject(OBJECT_TYPE_PLACEABLE, resref, GetLocation(GetNearestObjectByTag("e1_rte_sarcophagus_wp")), TRUE);
    SetUseableFlag(sarcophagusNew, FALSE);

    object trapDoorTest = GetNearestObjectByTag("e1_rte_to_teis_test");
    object trapDoor = GetNearestObjectByTag("e1_rte_to_teis");
    if (trapDoor != OBJECT_INVALID)
    {
        SetUseableFlag(trapDoor, TRUE);
    }

    if (trapDoorTest != OBJECT_INVALID)
    {
        SetUseableFlag(trapDoorTest, TRUE);
    }

    SetLocalInt(GetModule(), "e1OpenedPathToSanctum", 1);
}
