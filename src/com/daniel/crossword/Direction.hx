package com.daniel.crossword;

@:enum
abstract Direction(Int) from Int to Int {
	
	var N = 0;
	var NE = 1;
	var E = 2;
	var SE = 3;
	var S = 4;
	var SW = 5;
	var W = 6;
	var NW = 7;

	@:to
	function toString() : String {
		switch (this) {
			case 0: return "N";
			case 1: return "NE";
			case 2: return "E";
			case 3: return "SE";
			case 4: return "S";
			case 5: return "SW";
			case 6: return "W";
			case 7: return "NW";
		}
		#if debug
		throw "Error";
		#end
		return "-1";
	}

}

class DirectionUtil {

	static var deltaArr : Array<IntPair> = [
		new IntPair(0, -1),
		new IntPair(1, -1),
		new IntPair(1, 0),
		new IntPair(1, 1),
		new IntPair(0, 1),
		new IntPair(-1, -1),
		new IntPair(-1, 0),
		new IntPair(-1, -1)
	];
/*
	public static function init() {
		deltaArr = [
			new IntPair(0, -1),
			new IntPair(1, -1),
			new IntPair(1, 0),
			new IntPair(1, 1),
			new IntPair(0, 1),
			new IntPair(-1, -1),
			new IntPair(-1, 0),
			new IntPair(-1, -1)
		];
	}
*/
	public static inline function crossowrdDirs() : Array<Direction> return [S, E];

	public static inline function getDelta(dir : Direction) : IntPair {
	    return deltaArr[dir];
	}

	public static inline function getRotated90Delta(dir : Direction) {
		return deltaArr[(cast(dir, Int)+2)%8];
	}

	public static inline function getRotated180Delta(dir : Direction) {
		return deltaArr[(cast(dir, Int)+4)%8];
	}

	public static inline function getRotated270Delta(dir : Direction) {
		return deltaArr[(cast(dir, Int)+6)%8];
	}

}
