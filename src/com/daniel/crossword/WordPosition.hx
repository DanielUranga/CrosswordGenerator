package com.daniel.crossword;

class WordPosition {

	public var x : Int;
	public var y : Int;
	public var dir : Direction;

	public inline function new(x : Int, y : Int, dir : Direction) {
		this.x = x;
		this.y = y;
		this.dir = dir;
	}

	public function copy() {
		return new WordPosition(x, y, dir);
	}

}
