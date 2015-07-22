package com.daniel.crossword;

import com.daniel.crossword.Char;
import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.zip.Compress;
import haxe.zip.Uncompress;
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
		return this.wordCount = wc;
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
		if (isWordEnd) {
			thisNodeCharCount |= isWordEndFlag;
		}
		bytes.writeByte(thisNodeCharCount);
		/*
		if (thisNodeCharCount<=16) {
		*/
			// Less or equals 16 chars, add them one by one
			var keys = [];
			for (k in child.keys()) {
				keys.push(k);
			}
			keys.sort(function(x, y) return x-y);
			for (k in keys) {
				// Add char
				bytes.writeByte(k);
			}
		/*
		} else {
			// More than 16 chars, add them as bitmask
			var bArr = [];
			for (i in 0...16) {
				bArr.push(0);
			}
			for (k in child.keys()) {
				bArr[Std.int(k/8)] |= (1<<(k%8));
			}
			for (b in bArr) {
				bytes.writeByte(b);
			}
		}
		*/
	}

	public static function fromBytes(bytes : BytesInput) : StringSetNode {
		var newNode = new StringSetNode();
		var thisNodeCharCount = bytes.readByte();
		newNode.isWordEnd = (thisNodeCharCount&isWordEndFlag)!=0;
		thisNodeCharCount &= ~isWordEndFlag;
		/*
		if (thisNodeCharCount<=16) {
		*/
			// Less or equals 16 chars, read them one by one
			for (i in 0...thisNodeCharCount) {
				newNode.child[bytes.readByte()] = new StringSetNode();
			}
		/*
		} else {
			// More than 16 chars, read them as bitmask
			for (i in 0...16) {
				var b = bytes.readByte();
				for (j in 0...8) {
					if (b&(1<<j) != 0) {
						newNode.child[i*8+j] = new StringSetNode();
					}
				}
			}
		}
		*/
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
		var keys = [];
		for (k in rootNode.child.keys()) {
			keys.push(k);
		}
		keys.sort(function(x, y) return x-y);
		for (k in keys) {
			_compress(rootNode.child[k], bytes);
		}
	}

	public function compress() : Bytes {
		var out = new BytesOutput();
		_compress(root, out);
		return Compress.run(out.getBytes(), 9);
	}

	static function _fromCompressed(bytes : BytesInput) : StringSetNode {
		var rootNode = StringSetNode.fromBytes(bytes);
		var keys = [];
		for (k in rootNode.child.keys()) {
			keys.push(k);
		}
		keys.sort(function(x, y) return x-y);
		for (k in keys) {
			rootNode.child.set(k, _fromCompressed(bytes));
		}
		return rootNode;
	}	

	public static function fromCompressed(bytes : Bytes) : StringSet {
		var ret = new StringSet();
		var uBytes = Uncompress.run(bytes);
		ret.root = _fromCompressed(new BytesInput(uBytes));
		ret.root.updateWordCount();
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
