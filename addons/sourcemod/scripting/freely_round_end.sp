#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>


public Plugin myinfo = {
    name        = "Free Movement After Round End",
    author      = "Forgetest",
    description = "Allows players to move freely after the round ends in Versus mode",
    version     = "build_0000",
    url         = "https://github.com/TouchMe-Inc/l4d2_freely_round_end"
};


#define ROUND_END_REASON_VERSUS 5


/**
 * @brief Plugin initialization.
 *
 * This function is called when the plugin starts and hooks the round end event.
 */
public void OnPluginStart() {
    HookEvent("round_end", Event_RoundEnd);
}

/**
 * @brief Handles the round end event.
 *
 * @param eEvent The round end event.
 * @param szName The name of the event.
 * @param bDontBroadcast Flag indicating whether to broadcast the event.
 *
 * This function is called when the round end event occurs. If the reason for the round end matches the Versus mode, it requests a frame for further processing.
 */
void Event_RoundEnd(Event eEvent, const char[] szName, bool bDontBroadcast)
{
    int iReason = GetEventInt(eEvent, "reason");

    // Checking the reason for the round end
    if (iReason == ROUND_END_REASON_VERSUS) {
        // Requesting a frame for post-round end processing
        RequestFrame(OnFrame_RoundEnd);
    }
}

/**
 * @brief Handles the frame after the round end.
 *
 * This function is called after the round ends to remove the frozen and godmode flags from players, allowing them to move freely.
 */
void OnFrame_RoundEnd()
{
    for (int iClient = 1; iClient <= MaxClients; iClient++) {
        if (!IsClientInGame(iClient)) {
            continue;
        }

        // Removing the frozen and godmode flags
        int iFlags = GetEntityFlags(iClient);
        iFlags &= ~(FL_FROZEN | FL_GODMODE);
        SetEntityFlags(iClient, iFlags);
    }
}
