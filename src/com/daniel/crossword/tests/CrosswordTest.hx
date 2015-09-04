package com.daniel.crossword.tests;

import com.daniel.crossword.Crossword;
import com.daniel.crossword.CrosswordUtilRestrictedBoard;
import com.daniel.crossword.Direction;
import haxe.unit.TestCase;

class CrosswordTest extends TestCase {

	public function test() {
		var d = StringSet.fromCompressedFile("src/com/daniel/crossword/dict/ES.compressed");
		for (i in 0...10) {
			var c = CrosswordUtilRestrictedBoard.fillCrossword(12, 14, d);
			trace(c.toString());
		}
	}

}
