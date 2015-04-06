/*
marker
menMax
menRandomMax
customInit
groupId
*/

if (!isServer)exitWith{};

private ["_marker","_menMax","_menRandomMax","_customInit","_grpId","_milHQ","_milGroup","_buildings","_buildingPositions","_a","_building","_i","_i2","_pos","_unit"];

_marker = _this select 0;
_menMax = _this select 1;
_menRandomMax = _this select 2;
_customInit = _this select 3; if (!isNil("_customInit")) then {if (_customInit == "nil0") then {_customInit = nil;};};
_grpId = _this select 4;

_centerPos = getMarkerPos _marker;

_menAmount = _menMax + (round (random _menRandomMax));

diag_log format ["Creating guards for '%1' with '%2' men", _marker, _menAmount];

_buildings = [_marker] execVM "kryten\findNearBuidlings.sqf";

if (isNil("_buildings")) exitWith 
{
	diag_log format ["No buildings found switching to fillMarker for '%1'!", _marker];
	[_marker, 10, _menMax, _menRandomMax, 0, _customInit, _grpId] execVM "kryten\fillMarker.sqf";
};

if (count _buildings == 0) exitWith {};

_buildingPositions = [];
_a = 0;
while {_a < (count _buildings)} do {
	_building = (_buildings select _a);
	_i = 0;
	while {((_building buildingPos _i) select 0) != 0} do {
		_buildingPositions set [count (_buildingPositions), (_building buildingPos _i)];
		_i = _i + 1;
	};
	_a = _a + 1;
};

_milHQ = createCenter east;
_milGroup = createGroup east;

if (_menAmount > 0) then {
	for "_i2" from 1 to _menAmount do {
		_pos = _buildingPositions select floor (random count _buildingPositions);
		if (_menAmount < count _buildingPositions) then {_buildingPositions = _buildingPositions - [_pos];};
		
		_unit = [_centerPos, _radius, _milGroup] execVM "kryten\createRandomUnit.sqf";
		
		nul = [_x, 0.75] execVM "kryten\unitSetSkills.sqf";
		
		nul = [_unit, _centerPos, _radius, true] execVM "addons\AI_spawn\patrol-vG.sqf";
				
		if (!isNil("_customInit")) then {
		[_x, _customInit] execVM "kryten\unitSetCustomInit.sqf";
	};
	};
};

if (!isNil("_grpId")) then {
	call compile format ["LVgroup%1 = _milGroup", _grpId];
	call compile format ["LVgroup%1spawned = true", _grpId];
	_thisArray = [];
	{
		if (isNil("_x")) then {
			_thisArray set [(count _thisArray), "nil0"];
		} else {
			_thisArray set [(count _thisArray), _x];
		};
	} forEach _this;
	call compile format ["LVgroup%1CI = ['fillhouse',%2]", _grpId, _thisArray];
};
