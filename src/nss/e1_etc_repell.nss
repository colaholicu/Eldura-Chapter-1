void main()
{
    object enteringObj = GetEnteringObject();
    if (enteringObj != GetFirstPC())
    {
        AssignCommand(enteringObj, ClearAllActions(TRUE));
        AssignCommand(enteringObj, ActionMoveAwayFromObject(OBJECT_SELF, FALSE, 10.0f));
        DelayCommand(10.0f, AssignCommand(enteringObj, ActionRandomWalk()));
    }
}
