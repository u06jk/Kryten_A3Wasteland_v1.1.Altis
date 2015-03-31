/*
group,
skills
*/

private ["_group","_skills","_skillArray"];

_group = _this select 0;
_skills = _this select 1;

{
	_x setSkill ["aimingAccuracy", _skills];
	_x setSkill ["aimingShake", _skills];
    _x setSkill ["aimingSpeed", _skills];
    _x setSkill ["spotDistance", _skills];
    _x setSkill ["spotTime", _skills];
    _x setSkill ["courage", _skills];
    _x setSkill ["commanding", _skills];
    _x setSkill ["general", _skills];
	_x setSkill ["endurance", _skills];
	_x setSkill ["reloadspeed", _skills];
}forEach units group _group;