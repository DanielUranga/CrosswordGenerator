package com.daniel.crossword.tests;

import com.daniel.crossword.StringSet;
import com.daniel.crossword.StringUtil;
import haxe.io.BytesInput;
import haxe.unit.TestCase;
import sys.io.File;

@:access(com.daniel.crossword.StringSet)
class StringSetSerializationTest extends TestCase {

	function structureIsValid(node : StringSetNode, parent : StringSetNode, char : Char) : Bool {
		if (node.parent!=parent) {
			throw("node.parent!=parent");
			return false;
		}
		if (char!="*".code && char!=node.char) {
			throw("char!=node.char");
			return false;
		}
		for (k in node.child.keys()) {
			var c = node.child.get(k);
			if (!structureIsValid(c, node, k)) {
				return false;
			}
		}
		return true;
	}

	public function testFromUncompressedFile() {
		var strUtil = new StringUtil();
		var s = StringSet.fromUncompressedFile("src/com/daniel/crossword/dict/ES.dic");
		assertTrue(s.has(strUtil.encode("pestañearse")));
		assertTrue(s.has(strUtil.encode("retárdalas")));
		assertTrue(s.has(strUtil.encode("comentándooslos")));
		assertFalse(s.has("abcdefg"));
		var prevNums = [s.root.wordCount, s.root.updateWordCount(), s.nodeCount()];
		var comp = s.compress();
		File.saveBytes("src/com/daniel/crossword/dict/ES.compressed", comp);
		var sUncompressed = StringSet.fromCompressed(comp);
		var postNums = [sUncompressed.root.wordCount, sUncompressed.root.updateWordCount(), sUncompressed.nodeCount()];
		assertTrue(sUncompressed.has(strUtil.encode("pestañearse")));
		assertTrue(sUncompressed.has(strUtil.encode("retárdalas")));
		assertTrue(sUncompressed.has(strUtil.encode("comentándooslos")));
		assertFalse(sUncompressed.has("abcdefg"));
		assertTrue(structureIsValid(sUncompressed.root, null, "*"));
		
		assertEquals(prevNums[0], postNums[0]);
		assertEquals(prevNums[1], postNums[1]);
		assertEquals(prevNums[2], postNums[2]);
		
		sUncompressed.startFilter();
		sUncompressed.moveFilter("*");
		sUncompressed.moveFilter("a");
		sUncompressed.moveFilter("*");
		sUncompressed.moveFilter("l");
		sUncompressed.moveFilter("*");
		var filtered = sUncompressed.finishFilter();
		for (f in filtered) {
			assertTrue(f.charAt(1)=="a");
			assertTrue(f.charAt(3)=="l");
		}


	}

	public function testCompression() {
		var set = new StringSet();
		set.put("papanatas");
		set.put("sincronario");
		set.put("patata");
		set.put("papa");
		set.remove("papanatas");
		var bytes = set.compress();
		var prev = set.nodeCount();
		var recovered = StringSet.fromCompressed(bytes);
		assertEquals(prev, recovered.nodeCount());
	}

}
