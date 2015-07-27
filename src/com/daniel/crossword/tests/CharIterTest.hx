package com.daniel.crossword.tests;

import haxe.unit.TestCase;

using Lambda;

class CharIterTest extends TestCase {

	public function test() {
		var chars : Array<Char> = [];
		for (c in Char.firstChar...Char.lastChar+1) {
			chars.push(c);
		}
		assertTrue(chars.has(Char.fromString("a")));
		assertTrue(chars.has(Char.fromString("b")));
		assertTrue(chars.has(Char.fromString("x")));
		assertTrue(chars.has(Char.fromString("y")));
		assertEquals(chars[0], Char.firstChar);
		assertEquals(chars[chars.length-1], Char.lastChar);
	}
	
}
