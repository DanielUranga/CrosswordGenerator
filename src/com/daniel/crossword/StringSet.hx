package com.daniel.crossword;

import com.daniel.crossword.Char;
import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.zip.Compress;
import haxe.zip.Uncompress;
import sys.io.File;

private class SortedKeys {

	static var _sortedKeys : Array<Char>;

	public static function k() : Array<Char> {
		if (_sortedKeys==null) {
			_sortedKeys = [];
			for (c in Char.firstChar...Char.lastChar+1) {
				_sortedKeys.push(c);
			}
		}
		return _sortedKeys;
	}

}

class StringSetNode {

	public var child : Map<Char, StringSetNode>;
	public var wordCount : Int;
	public var isWordEnd : Bool;
	public var parent : StringSetNode;
	public var char : Char;

	public static inline var isWordEndFlag = 0x80;

	public function new(parent : StringSetNode, char : Char) {
		this.child = new Map<Char, StringSetNode>();
		this.isWordEnd = false;
		this.parent = parent;
		this.char = char;
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

	public static function updateReferences(node : StringSetNode, parent : StringSetNode, char : Char) {
		node.parent = parent;
		node.char = char;
		for (k in node.child.keys()) {
			var n = node.child.get(k);
			updateReferences(n, node, k);
		}
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
			for (k in SortedKeys.k()) {
				// Add char
				if (child.exists(k)) {
					bytes.writeByte(k);
				}
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
		var newNode = new StringSetNode(null, "*");
		var thisNodeCharCount = bytes.readByte();
		newNode.isWordEnd = (thisNodeCharCount&isWordEndFlag)!=0;
		thisNodeCharCount &= ~isWordEndFlag;
		/*
		if (thisNodeCharCount<=16) {
		*/
			// Less or equals 16 chars, read them one by one
			for (i in 0...thisNodeCharCount) {
				var c = bytes.readByte();
				newNode.child[c] = new StringSetNode(newNode, c);
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
	var filterIter : Array<StringSetNode>;
	var filtersCache : Map<String, Array<StringSetNode>>;

	public function new() {
		root = new StringSetNode(null, "*");
		filtersCache = new Map<String, Array<StringSetNode>>();
	}

	function updateFiltersCache() {
		var str = "";
		startFilter();
		for (i in 0...10) {
			str += "*";
			moveFilter("*");
			filtersCache.set(str, filterIter.copy());
		}
		finishFilter();
	}

	public function put(s : String) : Void {
		var itr = root;
		for (i in 0...s.length) {
			var c : Char = s.charAt(i);
			if (itr.get(c)==null) {
				itr.set(c, new StringSetNode(itr, c));
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

	// <Has>
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
	// </Has>

	// <Filter>
	var filterWord : String;
	public function startFilter() : Void {
		filterWord = "";
		filterIter = [root];
	}

	public function moveFilter(c : Char) : Void {
		filterWord += c.toString();
		if (filtersCache.exists(filterWord)) {
			filterIter = filtersCache.get(filterWord);
			return;
		}
		var prev = filterIter.copy();
		filterIter = [];
		if (c=="*") {
			for (p in prev) {
				for (k in p.child.keys()) {
					filterIter.push(p.child.get(k));
				}
			}
		} else {
			for (p in prev) {
				if (p.child.exists(c)) {
					filterIter.push(p.child.get(c));
				}
			}
		}
	}

	public function finishFilter() : Array<String> {
		var ret = new Array<String>();
		for (node in filterIter) {
			if (!node.isWordEnd) {
				continue;
			}
			var str = "";
			var itr = node;
			do {
				str = cast(itr.char, Char).toString() + str;
				itr = itr.parent;
			} while (itr!=null && itr!=root);
			ret.push(str);
		}
		return ret;
	}
	// </Filter>

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

	public static function getUncompressedBytes(bytes : Bytes) : BytesInput {
		var uBytes = Uncompress.run(bytes);
		return new BytesInput(uBytes);
	}

	static function skipOneChild(bytes : BytesInput) : Void {
		var thisNodeCharCount = bytes.readByte() & ~StringSetNode.isWordEndFlag;
		bytes.position += thisNodeCharCount;
		for (i in 0...thisNodeCharCount) {
			skipOneChild(bytes);
		}
	}

	// True if the child corresponding char is found
	static function _bytesHasWord(bytes : BytesInput, str : String) : Bool {
		var rootNode = StringSetNode.fromBytes(bytes);
		if (str.length==0) {
			return rootNode.isWordEnd;
		}
		var char : Char = Char.fromString(str);
		if (!rootNode.child.exists(char)) {
			return false;
		}
		for (k in SortedKeys.k()) {
			if (k == char) {
				return _bytesHasWord(bytes, str.substr(1));
			} else if (rootNode.child.exists(k)) {
				skipOneChild(bytes);
			}
		}
		return false;
	}

	public static function bytesHasWord(bytes : BytesInput, str : String, strUtil : StringUtil) : Bool {
		bytes.position = 0;
		return _bytesHasWord(bytes, strUtil.encode(str));
	}

	public static function bytesHasSimilarWord(bytes : BytesInput, str : String, strUtil : StringUtil) : String {
		var options = strUtil.generateOptionals(str);
		for (o in options) {
			if (bytesHasWord(bytes, o, strUtil)) {
				return o;
			}
		}
		return null;
	}

	static function _compress(rootNode : StringSetNode, bytes : BytesOutput) {
		rootNode.appendToBytes(bytes);
		for (k in SortedKeys.k()) {
			if (rootNode.child.exists(k)) {
				_compress(rootNode.child[k], bytes);
			}
		}
	}

	public function compress() : Bytes {
		var out = new BytesOutput();
		_compress(root, out);
		return Compress.run(out.getBytes(), 9);
	}

	static function _fromCompressed(bytes : BytesInput) : StringSetNode {
		var rootNode = StringSetNode.fromBytes(bytes);
		for (k in SortedKeys.k()) {
			if (rootNode.child.exists(k)) {
				rootNode.child.set(k, _fromCompressed(bytes));
			}
		}
		return rootNode;
	}

	public static function fromCompressed(bytes : Bytes) : StringSet {
		var ret = new StringSet();
		var uBytes = Uncompress.run(bytes);
		ret.root = _fromCompressed(new BytesInput(uBytes));
		ret.root.updateWordCount();
		StringSetNode.updateReferences(ret.root, null, "*");
		ret.updateFiltersCache();
		return ret;
	}

	public static function fromCompressedFile(path : String) : StringSet {
		Sys.print("\nLoading dictionary...");
		var ret = fromCompressed(File.getBytes(path));
		Sys.print(" Ready.\n");
		return ret;
	}

	public static function fromArray(words : Array<String>) {
		var strUtil = new StringUtil();
		var s = new StringSet();
		var count = 0;
		for (w in words) {
			s.put(strUtil.encode(w));
			count++;
			if (count%10000==0) {
				Sys.println(count + " words");
			}
		}
		s.updateFiltersCache();
		return s;
	}

	public static function fromUncompressedFile(path : String, ?corpora : Corporae = null) {
		Sys.print("\nLoading dictionary...");
		var ret = new StringSet();
		var f = File.read(path);
		var count = 0;
		var strUtil = new StringUtil();
		while (!f.eof()) {
			var word = "";
			try {
				word = f.readLine();
			} catch (d : Dynamic) {
				while (!f.eof()) {
					word += f.readString(1);
				}
			}
			if (word.length > 0) {
				if (corpora == null || corpora.contains(word)) {
					ret.put(strUtil.encode(word));
					if (count%10000==0) {
						Sys.println(count + " words");
					}
					count++;
				}
			}
		}
		f.close();
		Sys.print(" Ready.\n");
		return ret;
	}

}
