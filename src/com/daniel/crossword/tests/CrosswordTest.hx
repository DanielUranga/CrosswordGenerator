package com.daniel.crossword.tests;

import com.daniel.crossword.Crossword;
import haxe.unit.TestCase;
import com.daniel.crossword.CrosswordUtilRestrictedBoard;

class CrosswordTest extends TestCase {

	public function test() {
		var d = StringSet.fromCompressedFile("src/com/daniel/crossword/dict/ES.compressed");
		for (i in 0...15) {
			var c = new Crossword();
			var iterationsWithouthAdding = 0;
			var total = 0;
			while (iterationsWithouthAdding<50) {
				var randomFactor = 10;
				randomFactor -= Std.int(iterationsWithouthAdding/4);
				if (randomFactor<0) {
					randomFactor = 0;
				}
				if (CrosswordUtilRestrictedBoard.tryAddRandomWord(c, 12, 14, d, Std.random(randomFactor)+3)) {
					iterationsWithouthAdding = 0;
				} else {
					iterationsWithouthAdding++;
				}
				total++;
			}
			Sys.println(c.toSerializedFormat());
		}
	}

}
