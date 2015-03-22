// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
/*********************************************************#
# @@ScriptName: createCaptureTriggers.sqf
# @@Author: Nick 'Bewilderbeest' Ludlam <bewilder@recoil.org>, AgentRev
# @@Create Date: 2013-09-15 16:26:38
# @@Modify Date: 2013-09-15 22:35:19
# @@Function: Creates server-side capture zone triggers
#*********************************************************/

if (!isServer) exitWith {};

{
	_marker = _x;
	
	if (["TERRITORY_", _marker] call fn_startsWith) then
	{
		if ({_x select 0 == _marker} count (["config_territory_markers", []] call getPublicVar) > 0) then
		{
			diag_log format ["Creating territory capture trigger and guards for '%1'", _marker];
			_trig = createTrigger ["EmptyDetector", markerPos _marker];
			_trig setVariable ["captureTriggerMarker", _marker, true];
			
			if (["A3W_kryten_spawnGuards"], 1] call getPublicVar >= 1) then {
				//Set default guards
				_size = getMarkerSize _marker;
				_radius = (_size select 0) min (_size select 1);
				_customInit = "[[this], 'A3W_fnc_disableFF',true, true] call BIS_fnc_MP; this addEventHandler ['Killed', server_playerDied]; this setVariable ['isGuard',true,true];";
				_groupID = nil;
				
				[_marker, _radius, 5, 5, 2, _customInit, if (isNil "_groupID") then {nil} else {_groupID}] execVM "addons\AI_spawn\militarizeK.sqf";
			};
		}
		else
		{
			diag_log format ["WARNING: No config_territory_markers definition for marker '%1'. Deleting it!", _marker];
			deleteMarker _marker;
		};
	};
	
	if (["A3W_kryten_spawnGuards"], 1] call getPublicVar >= 1) then {
		if ((["GunStore", _marker] call fn_startsWith) or (["GenStore", _marker] call fn_startsWith) or (["VehStore", _marker] call fn_startsWith)) then
		{
			if ((count _marker) == 9) then
			{
				diag_log format ["Creating guards for '%1'", _marker];
				
				//Set default guards
				_customInit = "[[this], 'A3W_fnc_disableFF',true, true] call BIS_fnc_MP; this addEventHandler ['Killed', server_playerDied]; this setVariable ['isGuard',true,true];";
				_groupID = nil;
				
				[_marker, 2, 2, _customInit, if (isNil "_groupID") then {nil} else {_groupID}] execVM "addons\AI_spawn\fillHouseK.sqf";
			}
		};
	};
} forEach allMapMarkers;

// Create random group in cities.
//_cities = call cityList;