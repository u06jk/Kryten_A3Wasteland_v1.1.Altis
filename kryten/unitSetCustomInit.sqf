/*
unit,
customInit
*/

private["_unit","_customInit","_array0","_num","_globalUnit"];

_unit = _this select 0;
_customInit = _this select 1;

_array0 = toArray(str(_customInit));
_globalUnit = false;
_num = 0;
_scolons = 0;
_commandms = [];
for [{_i=1}, {_i<(count _array0)}, {_i=_i+1}] do{
	if(((_array0 select _i) == 116)&&((count _array0)>(_i+3)))then{ 
	   if((_i > 0)&&((_array0 select (_i-1)) == 95))then{
	     _commandms set[(count _commandms), (_array0 select _i)];
	   }else{
		if(((_array0 select (_i+1)) == 104)&&((_array0 select (_i+2)) == 105)&&((_array0 select (_i+3)) == 115))then{
			if(!_globalUnit)then{
				while{!(isNil("KVIUID"+(str _num)))}do{
					_num = _num + 1;
				};
				call compile format ["KVIUID%1 = _unit",_num];
			};
			
			_unArr = toArray("KVIUID"+(str _num));
			_a = 0;
			while {_a < (count _unArr) }do{
				_commandms set[(count _commandms), (_unArr select _a)];
				_a = _a + 1;
			};
			_globalUnit = true;
			_i = _i + 3;
		}else{
			_commandms set[(count _commandms), (_array0 select _i)];
		};
	   };
	}else{
		_commandms set[(count _commandms), (_array0 select _i)];
	};
	
    if((_array0 select _i) == 59)then{
		_scolons = _scolons + 1;
		[toString(_commandms)] call {
			_cmd = _this select 0;
			call compile format["%1",_cmd];
		};
		_commandms = [];
	};
};

if(_globalUnit)then{
	call compile format ["KVIUID%1 = nil",_num];
};
