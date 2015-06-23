package com.daniel.crossword;

import haxe.ds.Vector;

class StringSet {

	var wordHash : Vector<Array<String>>;
	public var size(default, null) : Int;

	public function new() {
		wordHash = new Vector<Array<String>>(1024);
		size = 0;
	}

	/**
	 * Compute string hash using sdbm algorithm.
	 * 
	 * This algorithm was created for sdbm (a public-domain reimplementation of ndbm) database library.
	 * It was found to do well in scrambling bits, causing better distribution of the keys and fewer splits.
	 * It also happens to be a good general hashing function with good distribution.
	 * @see http://www.cse.yorku.ca/~oz/hash.html
	 */
	function hash(s : String) : Int {
		var hash = 0;
		for (i in 0...s.length) {
			hash = s.charCodeAt(i) + (hash << 6) + (hash << 16) - hash;
		}
		hash %= wordHash.length;
		return hash<0 ? -hash : hash;
	}

	public function put(s : String) : Void {
		var h = hash(s);
		var arr = wordHash.get(h);
		if (arr==null) {
			wordHash.set(h, [s]);
		} else {
			arr.push(s);
		}
		size++;
	}

	public function has(s : String) : Bool {
		var h = hash(s);
		var arr = wordHash.get(h);
		if (arr==null) {
			return false;
		}
		for (sArr in arr) {
			if (sArr==s) {
				return true;
			}
		}
		return false;
	}

	public function remove(s : String) : Void {
		var h = hash(s);
		var arr = wordHash.get(h);
		if (arr==null) {
			return;
		}
		arr.remove(s);
		size--;
	}

	public static function fromArray(words : Array<String>) {
		var s = new StringSet();
		for (w in words) {
			s.put(w);
		}
		return s;
	}

}
