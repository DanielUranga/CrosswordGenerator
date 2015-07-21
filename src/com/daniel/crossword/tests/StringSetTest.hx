package com.daniel.crossword.tests;

import com.daniel.crossword.Char;
import com.daniel.crossword.StringSet;
import haxe.unit.TestCase;

@:access(com.daniel.crossword.StringSet)
class StringSetTest extends TestCase {

	public function test() {

		var set = new StringSet();
		set.put("papanatas");
		set.put("sincronario");
		set.put("patata");
		set.put("papa");
		set.remove("papanatas");

		assertFalse(set.has("pa"));
		assertFalse(set.has("pap"));
		assertTrue(set.has("sincronario"));
		assertTrue(set.has("patata"));

		var notFound = ["papanatas", "patatas", "patat"];
		for (w in notFound) {
			var found = true;
			set.startHas();
			for (i in 0...w.length) {
				set.moveHas(w.charAt(i));
			}
			found = set.finishHas();
			assertFalse(found);
		}

		var found = ["sincronario", "patata", "papa"];
		for (w in found) {
			var found = true;
			set.startHas();
			for (i in 0...w.length) {
				set.moveHas(w.charAt(i));
			}
			found = set.finishHas();
			assertTrue(found);
		}

		assertEquals(set.root.wordCount, set.root.updateWordCount());

	}

}
