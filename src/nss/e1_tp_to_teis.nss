void main()
{
    object luther = GetObjectByTag("e1_luther_old");
    SetPlotFlag(luther, FALSE);
    DestroyObject(luther);

    AssignCommand(GetFirstPC(), ActionJumpToObject(GetObjectByTag("e1_teis_from_rte")));
}
