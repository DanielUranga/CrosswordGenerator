package com.daniel.crossword.tests;

import com.daniel.crossword.Crossword;
import haxe.unit.TestCase;
import com.daniel.crossword.CrosswordUtilRestrictedBoard;

class CrosswordTest extends TestCase {

	public function test() {
		var c = new Crossword();
		var d = StringSet.fromCompressedFile("src/com/daniel/crossword/dict/ES.compressed");
		var iterationsWithouthAdding = 0;
		var total = 0;
		while (iterationsWithouthAdding<50) {
			if (CrosswordUtilRestrictedBoard.tryAddRandomWord(c, 15, 15, d, Std.random(7)+3)) {
				iterationsWithouthAdding = 0;
			} else {
				iterationsWithouthAdding++;
			}
			total++;
		}
		trace("Total: " + total);
		trace(c.toString());
	}

}
