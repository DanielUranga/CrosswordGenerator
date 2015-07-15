package com.daniel.crossword;

class StringSet {

	var map : Map<String, Bool>;

	public function new() {
		map = new Map<String, Bool>();
	}

	public function put(s : String) : Void {
		map.set(s, true);
	}

	public function has(s : String) : Bool {
		return map.get(s)==true;
	}

	public function remove(s : String) : Void {
		map.remove(s);
	}

	public static function fromArray(words : Array<String>) {
		var s = new StringSet();
		for (w in words) {
			s.put(w);
		}
		return s;
	}

}
