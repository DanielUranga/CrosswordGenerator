package com.daniel.crossword.tests;

import com.daniel.crossword.Corporae;
import haxe.unit.TestCase;
import sys.io.File;

class CorporaeTest extends TestCase {

	public function test() {
		var corporae = new Corporae();
		var paths = [];
		for (i in 0...10) {
			paths.push("src/com/daniel/crossword/corporae/spanish_billion_words_0" + i);
		}
		for (i in 10...100) {
			paths.push("src/com/daniel/crossword/corporae/spanish_billion_words_" + i);
		}
		corporae.load(paths);
		var json = corporae.toJson();
		File.saveContent("src/com/daniel/crossword/corporae/wordfreqs.json", json);
		assertTrue(true);
	}
	
}
