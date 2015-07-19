package com.daniel.crossword;

import com.daniel.crossword.Char;

private class StringSetNode {

	public var child : Map<Char, StringSetNode>;
	public var count : Int;
	public var isWordEnd : Bool;

	public function new() {
		this.child = new Map<Char, StringSetNode>();
		this.count = 0;
		this.isWordEnd = true;
	}

	public inline function get(c : Char) {
		return child.get(c);
	}

	public inline function set(c : Char, node : StringSetNode) {
		return child.set(c, node);
	}

	public inline function remove(c : Char) {
		return child.remove(c);
	}

}

class StringSet {

	var root : StringSetNode;
	var hasIter : StringSetNode;

	public function new() {
		root = new StringSetNode();
	}

	public function put(s : String) : Void {
		var itr = root;
		for (i in 0...s.length) {
			var c : Char = s.charAt(i);
			if (itr.get(c)==null) {
				itr.set(c, new StringSetNode());
			}
			itr.count++;
			itr = itr.get(c);
		}
		itr.isWordEnd = true;
	}

	public function startHas() {
		hasIter = root;
	}

	public function moveHas(c : Char) : Bool {
		if (hasIter==null || hasIter.count<=0) {
			return false;
		}
		hasIter = hasIter.get(c);
		if (hasIter==null || hasIter.count<=0) {
			return false;
		}
		return true;
	}

	public function finishHas() : Bool {
		return hasIter.isWordEnd;
	}
/*
	public function has(s : String) : Bool {
		var itr = root;
		for (i in 0...s.length) {
			var c : Char = s.charAt(i);
			if (itr.get(c)==null) {
				return false;
			}
			itr = itr.get(c);	
		}
		return true;
	}
*/
	public function remove(s : String) : Void {
		var itr = root;
		var parent : StringSetNode = null;
		for (i in 0...s.length) {
			var c : Char = s.charAt(i);
			if (itr.get(c)==null) {
				return;
			}
			itr.count--;
			if (itr.count==0 && parent!=null) {
				var cPrev : Char = s.charAt(i-1);
				parent.remove(cPrev);
			}
			parent = itr;
			itr = itr.get(c);
		}
	}

	public static function fromArray(words : Array<String>) {
		var s = new StringSet();
		for (w in words) {
			s.put(w);
		}
		return s;
	}

}
