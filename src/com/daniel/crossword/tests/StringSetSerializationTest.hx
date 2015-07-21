package com.daniel.crossword.tests;

import com.daniel.crossword.StringSet;
import com.daniel.crossword.StringUtil;
import haxe.io.BytesInput;
import haxe.unit.TestCase;

class StringSetSerializationTest extends TestCase {

	public function testFromUncompressedFile() {
		var s = StringSet.fromUncompressedFile("src/com/daniel/crossword/dict/ES.dic");
		assertTrue(s.has("cope"));
		assertTrue(s.has("hispanoamericanos"));
		assertTrue(s.has(StringUtil.encode("industrializarías")));
		assertFalse(s.has("abcdefg"));
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
		var recovered = StringSet.fromCompressed(new BytesInput(bytes));
		assertEquals(prev, recovered.nodeCount());
	}

}
