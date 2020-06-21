void main()
{
     object door = GetNearestObjectByTag("e1_purgatory_door");
     SetLocked(door, FALSE);
     AssignCommand(door, ActionOpenDoor(door));
}
