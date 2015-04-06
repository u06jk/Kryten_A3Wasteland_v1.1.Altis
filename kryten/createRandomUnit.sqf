/*
position,
radius,
milGroup
*/

if (!isServer)exitWith{};

private ["_position","_radius","_milGroup","_unit","_weapon","_antiTank","_antiAir"];

_position = _this select 0;
_radius = _this select 1;
_milGroup = _this select 2;

_weapon = floor random 8;
_antiTank = [false,false,false,true] call BIS_fnc_selectRandom;
_antiAir = [false,false,false,true] call BIS_fnc_selectRandom;

_unit = [_centerPos, _radius, _milGroup, _weapon, _antiTank, _antiAir] execVM "kryten\createUnit.sqf";

_unit