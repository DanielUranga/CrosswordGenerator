package com.daniel.crossword;

import com.daniel.crossword.Char;
import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import sys.io.File;

private class StringSetNode {

	public var child : Map<Char, StringSetNode>;
	public var wordCount : Int;
	public var isWordEnd : Bool;

	static inline var isWordEndFlag = 0x80;

	public function new() {
		this.child = new Map<Char, StringSetNode>();
		this.isWordEnd = false;
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

	public function updateWordCount() : Int {
		var wc = 0;
		for (c in child) {
			wc += c.updateWordCount();
		}
		if (isWordEnd) {
			wc++;
		}
		return wc;
	}

	public function nodeCount() : Int {
		var count = 0;
		for (c in child) {
			count += c.nodeCount();
		}
		return count + 1;
	}

	public function appendToBytes(bytes : BytesOutput) {

		var thisNodeCharCount = 0;
		for (c in child) {
			thisNodeCharCount++;
		}

		// Add node count + isWordEnd marker
		bytes.writeByte(thisNodeCharCount | isWordEndFlag);

		for (k in child.keys()) {
			// Add char
			bytes.writeByte(k);
		}

	}

	public static function fromBytes(bytes : BytesInput) : StringSetNode {
		var newNode = new StringSetNode();
		var count = bytes.readByte();
		newNode.isWordEnd = (count&isWordEndFlag)!=0;
		count &= ~isWordEndFlag;
		for (i in 0...count) {
			newNode.child[bytes.readByte()] = new StringSetNode();
		}
		return newNode;
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
			itr.wordCount++;
			itr = itr.get(c);
		}
		itr.wordCount++;
		itr.isWordEnd = true;
	}

	public function nodeCount() : Int {
		return root.nodeCount();
	}

	public function startHas() {
		hasIter = root;
	}

	public function moveHas(c : Char) {
		if (hasIter==null || hasIter.wordCount<=0) {
			return;
		}
		hasIter = hasIter.get(c);
	}

	public function finishHas() : Bool {
		if (hasIter==null) {
			return false;
		}
		return hasIter.isWordEnd;
	}

	public function has(s : String) : Bool {
		var itr = root;
		for (i in 0...s.length) {
			var c : Char = s.charAt(i);
			if (itr.get(c)==null) {
				return false;
			}
			itr = itr.get(c);
		}
		if (itr==null) {
			return false;
		}
		return itr.isWordEnd;
	}

	public function remove(s : String) : Void {
		var itr = root;
		var parent : StringSetNode = null;
		for (i in 0...s.length) {
			var c : Char = s.charAt(i);
			if (itr.get(c)==null) {
				return;
			}
			itr.wordCount--;
			if (itr.wordCount==0 && parent!=null) {
				var cPrev : Char = s.charAt(i-1);
				parent.remove(cPrev);
			}
			parent = itr;
			itr = itr.get(c);
		}
	}

	static function _compress(rootNode : StringSetNode, bytes : BytesOutput) {
		rootNode.appendToBytes(bytes);
		for (c in rootNode.child) {
			_compress(c, bytes);
		}
	}

	public function compress() : Bytes {
		var out = new BytesOutput();
		_compress(root, out);
		return out.getBytes();
	}

	static function _fromCompressed(bytes : BytesInput) : StringSetNode {
		var rootNode = StringSetNode.fromBytes(bytes);
		for (k in rootNode.child.keys()) {
			rootNode.child.set(k, _fromCompressed(bytes));
		}
		return rootNode;
	}

	public static function fromCompressed(bytes : BytesInput) : StringSet {
		var ret = new StringSet();
		ret.root = _fromCompressed(bytes);
		return ret;
	}

	public static function fromArray(words : Array<String>) {
		var s = new StringSet();
		for (w in words) {
			s.put(StringUtil.encode(w));
		}
		return s;
	}

	public static function fromUncompressedFile(path : String) {
		return fromArray(File.getContent(path).split("\n"));
	}

}
