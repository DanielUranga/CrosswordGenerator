package com.daniel.crossword.tests;

import com.daniel.crossword.StringSet;
import com.daniel.crossword.StringUtil;
import haxe.io.BytesInput;
import haxe.unit.TestCase;
import sys.io.File;

@:access(com.daniel.crossword.StringSet)
class StringSetSerializationTest extends TestCase {

	public function testFromUncompressedFile() {
		var s = StringSet.fromUncompressedFile("src/com/daniel/crossword/dict/ES.dic");
		assertTrue(s.has("cope"));
		assertTrue(s.has("hispanoamericanos"));
		assertTrue(s.has(StringUtil.encode("industrializarías")));
		assertFalse(s.has("abcdefg"));
		var prevNums = [s.root.wordCount, s.root.updateWordCount(), s.nodeCount()];
		var comp = s.compress();
		File.saveBytes("src/com/daniel/crossword/dict/ES.compressed", comp);
		var sUncompressed = StringSet.fromCompressed(comp);
		var postNums = [sUncompressed.root.wordCount, sUncompressed.root.updateWordCount(), sUncompressed.nodeCount()];
		assertTrue(sUncompressed.has("cope"));
		assertTrue(sUncompressed.has("hispanoamericanos"));
		assertTrue(sUncompressed.has(StringUtil.encode("industrializarías")));
		assertFalse(sUncompressed.has("abcdefg"));
		for (i in 0...3) {
			assertEquals(prevNums[i], postNums[i]);
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
