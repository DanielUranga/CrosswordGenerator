package com.daniel.crossword.tests;

import com.daniel.crossword.Crossword;
import com.daniel.crossword.CrosswordUtilRestrictedBoard;
import com.daniel.crossword.Direction;
import haxe.unit.TestCase;

class CrosswordTest extends TestCase {

	public function test() {
		//var d = StringSet.fromCompressedFile("src/com/daniel/crossword/dict/ES.compressed");
		var d = StringSet.fromUncompressedFile("src/com/daniel/crossword/dict/ES.dic");
		//var d = StringSet.fromUncompressedFile("src/com/daniel/crossword/dict/ES_hunspell.dic");
		for (i in 0...10) {
			var c = CrosswordUtilRestrictedBoard.fillCrossword(12, 14, d);
			Sys.println(c.toString());
			Sys.println('(${c.score()})');
		}
		assertTrue(true);
	}

}
