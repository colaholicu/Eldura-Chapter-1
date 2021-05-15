void main()
{
    AssignCommand(OBJECT_SELF, ActionStartConversation(GetFirstPC(), GetLocalString(OBJECT_SELF, "Conversation"), FALSE, FALSE));
}
