package com.daniel.crossword.tests;

import com.daniel.crossword.StringSet;
import com.daniel.crossword.StringUtil;
import haxe.unit.TestCase;

class StringSetSerializationTest extends TestCase {

	public function testFromUncompressedFile() {
		var s = StringSet.fromUncompressedFile("src/com/daniel/crossword/dict/ES.dic");
		assertTrue(s.has("cope"));
		assertTrue(s.has("hispanoamericanos"));
		assertTrue(s.has(StringUtil.encode("industrializarías")));
		assertFalse(s.has("abcdefg"));
	}

}
