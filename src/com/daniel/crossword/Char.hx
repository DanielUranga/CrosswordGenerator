package com.daniel.crossword;

abstract Char(Int) from Int to Int {
	
	inline public function new(i:Int) {
		this = i;
	}

	@:from
	static public function fromString(s:String) {
		return new Char(s.charCodeAt(0));
	}

	@:to
	public function toString() : String {
		return String.fromCharCode(this);
	}

}
