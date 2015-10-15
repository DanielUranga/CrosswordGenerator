package com.daniel.crossword;

class CharIterator {

	var c : Char;

	public function new(c : Char) {
		this.c = c;
	}

	public inline function next() : Char {
		return c++;
	}

	public inline function hastNext() : Bool {
		return c<Char.lastChar;
	}

}

abstract Char(Int) from Int to Int {

	static var toStringTable = [
		"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l",
		"m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x",
		"y", "z", "0", "1", "2", "3", "4", "5", "*", "_"
	];

	static var fromStringTable = [
		"a"=>0, "b"=>1, "c"=>2, "d"=>3, "e"=>4, "f"=>5, "g"=>6, "h"=>7,
		"i"=>8, "j"=>9, "k"=>10, "l"=>11,	"m"=>12, "n"=>13, "o"=>14, "p"=>15,
		"q"=>16, "r"=>17, "s"=>18, "t"=>19, "u"=>20, "v"=>21, "w"=>22, "x"=>23,
		"y"=>24, "z"=>25, "0"=>26, "1"=>27, "2"=>28, "3"=>29, "4"=>30, "5"=>31,
		"*"=>32, "_"=>33
	];

	public static inline var firstChar : Char = 0;
	public static inline var lastChar : Char = 33;

	inline public function new(i:Int) {
		this = i;
	}

	public function iterator() {
		return new CharIterator(this);
	}

	@:op(A > B) static function gt(a:Char, b:Char) : Bool;
	@:op(A < B) static function lt(a:Char, b:Char) : Bool;
	@:op(A == B) static function eq(a:Char, b:Char) : Bool;
	@:op(A + B) static function eq(a:Char, b:Char) : Char;

	@:from
	static public function fromString(s:String) : Char {
		return fromStringTable.get(s.charAt(0));
	}

	@:to
	public function toString() : String {
		return new String(toStringTable[this]);
	}

}
