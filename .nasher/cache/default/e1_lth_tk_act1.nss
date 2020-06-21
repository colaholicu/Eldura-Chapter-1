void main()
{
    object item = GetNextItemInInventory(GetPCSpeaker());
    while (item != OBJECT_INVALID)
    {
        if (GetTag(item) == "e1_luther_bloodied_note")
        {
            break;
        }

        item = GetNextItemInInventory(GetPCSpeaker());
    }

    if (item == OBJECT_INVALID)
    {
        return;
    }

    AssignCommand(GetPCSpeaker(), ActionGiveItem(item, GetNearestObjectByTag("e1_luther_old")));
}
