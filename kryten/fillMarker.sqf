/*
marker
radius
menMax
menRandomMax
vehMax
customInit
groupId
*/

if (!isServer)exitWith{};

private ["_marker","_radius","_menMax","_menRandomMax","_vehMax","_customInit","_grpId","_centerPos","_menAmount","_vehAmount","_airAmount","_allUnitsArray","_milHQ","_milGroup","_unit","_vehicle"];

_marker = _this select 0;
_radius = _this select 1;
_menMax = _this select 2;
_menRandomMax = _this select 3;
_vehMax = _this select 4;
_customInit = _this select 5; if(!isNil("_customInit")) then {if(_customInit == "nil0") then {_customInit =nil;};};
_grpId = _this select 6;

_centerPos = getMarkerPos _marker;

_menAmount = _menMax + (round (random _menRandomMax));
_vehAmount = (round (random _vehMax));
_airAmount = (round (random 1));

diag_log format ["Creating guards for '%1' with '%2' men and '%3' vehicles", _marker, _menAmount, _vehAmount];

_allUnitsArray = [];
_milHQ = createCenter east;
_milGroup = createGroup east;

if (_menAmount > 0) then {
	for "_i" from 1 to _menAmount do {
		_unit = [_centerPos, _radius, _milGroup] execVM "kryten\createRandomUnit.sqf";
		
		nul = [_unit, _centerPos, _radius, true] execVM "addons\AI_spawn\patrol-vD.sqf";
		
		_unit allowDamage false;
		_allUnitsArray set [(count _allUnitsArray), _unit];
	};
};

if (_vehAmount > 0) then {
	for "_i" from 1 to _vehAmount do {
		_vehicle = [_centerPos, _milGroup] execVM "kryten\createLandVehicle.sqf";
		
		nul = [_vehicle, _centerPos] execVM "addons\AI_spawn\patrol-vE.sqf";
		
		_vehicle allowDamage false;
        
        _allUnitsArray set [(count _allUnitsArray), _vehicle];
	};
};

if (_airAmount > 0) then {
	for "_i" from 1 to _airAmount do {
		_vehicle = [_centerPos, _milGroup] execVM "kryten\createAirVehicle.sqf";
		
		nul = [_vehicle, _centerPos] execVM "addons\AI_spawn\patrol-vE.sqf";
		
		_vehicle allowDamage false;
        
        _allUnitsArray set [(count _allUnitsArray), _vehicle];
	};
};

_milGroup setBehaviour "COMBAT";

{
	nul = [_x, 0.75] execVM "kryten\unitSetSkills.sqf";
	if (!isNil("_customInit")) then {
		[_x, _customInit] execVM "kryten\unitSetCustomInit.sqf";
	};
} forEach units _milGroup;

sleep 3;
{
	_x allowDamage true;
} forEach _allUnitsArray;

if (!isNil("_grpId")) then {
	call compile format ["Kgroup%1 = _milGroup", _grpId];
	call compile format ["Kroup%1spawned = true", _grpId];
	_thisArray = [];
	{
		if (isNil("_x")) then {
			_thisArray set [(count _thisArray), "nil0"];
		} else {
			_thisArray set [(count _thisArray), _x];
		};
	} forEach _this;
	call compile format ["Kgroup%1CI = ['fillMarker',%2]", _grpId, _thisArray];
};
