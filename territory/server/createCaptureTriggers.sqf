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
			diag_log format ["Creating territory capture trigger for '%1'", _marker];
			_trig = createTrigger ["EmptyDetector", markerPos _marker];
			_trig setVariable ["captureTriggerMarker", _marker, true];
			
            //Set default guards
			_pos = markerPos _marker;
			_numSide = 2;
			_size = getMarkerSize _marker;
			_dir = "random"; //markerDir _captureName
			_radius = (_size select 0) max (_size select 1);
			_spawnInfantry = [true,false]; //Land, Water
			_spawnVehicles = [true,false,false]; //Land,Water,Air
			_stayStill = false; //Stay still and do not patrol
			_infantryAlways = 5;
			_infantryRandom = 5;
			_vehiclesAlways = 0;
			_vehiclesRandom = 1;
			_aiSkills = 0.75; //Default or an array
			_groupID = nil;
      
			//_customInit = "[[this], 'A3W_fnc_disableFF',true, true] call BIS_fnc_MP; this setSpeaker 'NoVoice'; this addEventHandler ['Killed', server_playerDied]; this setVariable ['isGuard',true,true];";
			_customInit = nil;
			_territoryID = nil;
      
			[_pos,_numSide,_radius,_spawnInfantry,_spawnVehicles,_stayStill,[_infantryAlways,_infantryRandom],[_vehiclesAlways,_vehiclesRandom],_aiSkills, if (isNil "_groupID") then {nil} else {_groupID}, if (isNil "_customInit") then {nil} else {_customInit},if (isNil "_territoryID") then {nil} else {_territoryID}] execVM "addons\AI_spawn\militarize.sqf";
		}
		else
		{
			diag_log format ["WARNING: No config_territory_markers definition for marker '%1'. Deleting it!", _marker];
			deleteMarker _marker;
		};
	};
	
	if (["GunStore", _marker] call fn_startsWith) then
	{
		diag_log format ["Creating guard for gun store '%1'", _marker];
	
		//Set default guards
		_target = markerPos _marker;
		_side = 2;
		_patrol = true;
		_patrolType = 2;
		_spawnAlways = 2;
		_spawnRandom = 2;
		_radius = 1;
		_skills = 0.75;
		_group = nil;
		//_customInit = "[[this], 'A3W_fnc_disableFF',true, true] call BIS_fnc_MP; this setSpeaker 'NoVoice'; this addEventHandler ['Killed', server_playerDied]; this setVariable ['isGuard',true,true];";
		_customInit = nil;
		_id = nil;
		
		[_target, _side, _patrol, _patrolType, [_spawnAlways, _spawnRandom], _radius, _skills, if (isNil "_group") then {nil} else {_group}, if (isNil "_customInit") then {nil} else {_customInit}, if (isNil "_id") then {nil} else {_id}] execVM "addons\AI_spawn\fillHouse.sqf";
	};
	
	if (["VehStore", _marker] call fn_startsWith) then
	{
		diag_log format ["Creating guard for vehicle store '%1'", _marker];
	
		//Set default guards
		_target = markerPos _marker;
		_side = 2;
		_patrol = true;
		_patrolType = 2;
		_spawnAlways = 2;
		_spawnRandom = 2;
		_radius = 1;
		_skills = 0.5;
		_group = nil;
		//_customInit = "[[this], 'A3W_fnc_disableFF',true, true] call BIS_fnc_MP; this setSpeaker 'NoVoice'; this addEventHandler ['Killed', server_playerDied]; this setVariable ['isGuard',true,true];";
		_customInit = nil;
		_id = nil;
		
		[_target, _side, _patrol, _patrolType, [_spawnAlways, _spawnRandom], _radius, _skills, if (isNil "_group") then {nil} else {_group}, if (isNil "_customInit") then {nil} else {_customInit}, if (isNil "_id") then {nil} else {_id}] execVM "addons\AI_spawn\fillHouse.sqf";
	};
	
	if (["GenStore", _marker] call fn_startsWith) then
	{
		diag_log format ["Creating guard for general store '%1'", _marker];
	
		//Set default guards
		_target = markerPos _marker;
		_side = 2;
		_patrol = true;
		_patrolType = 2;
		_spawnAlways = 2;
		_spawnRandom = 2;
		_radius = 1;
		_skills = 0.5;
		_group = nil;
		//_customInit = "[[this], 'A3W_fnc_disableFF',true, true] call BIS_fnc_MP; this setSpeaker 'NoVoice'; this addEventHandler ['Killed', server_playerDied]; this setVariable ['isGuard',true,true];";
		_customInit = nil;
		_id = nil;
		
		[_target, _side, _patrol, _patrolType, [_spawnAlways, _spawnRandom], _radius, _skills, if (isNil "_group") then {nil} else {_group}, if (isNil "_customInit") then {nil} else {_customInit}, if (isNil "_id") then {nil} else {_id}] execVM "addons\AI_spawn\fillHouse.sqf";
	};
} forEach allMapMarkers;
