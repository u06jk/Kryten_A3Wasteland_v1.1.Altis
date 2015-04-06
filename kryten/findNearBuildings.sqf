/*
marker
*/

if (!isServer)exitWith{};

private ["_marker","_radius","_center","_buildingObjects","_buildings"];
	
_marker = _this select 0;
	
_radius = 15;
	
_center = getMarkerPos _marker;
	
_buildingObjects = nearestObjects [_center, ["building"], _radius];
	
if (isNil("_buildingObjects")) exitWith{diag_log format ["No buildings found for '%1' within '%2'", _marker, _radius]};
if (count _buildingObjects == 0) exitWith{};
	
_buildings = [];
{
	if (str (_x buildingPos 0) != "[0,0,0]") then {_buildings set[(count _buildings), _x];};
} forEach _buildingObjects;
	
if (count _buildings == 0) exitWith{diag_log "No buildings found!"};
	
_buildings;