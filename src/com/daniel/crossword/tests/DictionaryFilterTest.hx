package com.daniel.crossword.tests;
import haxe.unit.TestCase;

import sys.io.File;

class DictionaryFilterTest extends TestCase {

	public function test() {
		var corpora = new Corporae();
		
		trace(1);
		corpora.fromJson(File.getContent("src/com/daniel/crossword/corporae/wordfreqs.json"));
		trace(2);
		
		DictionaryFilter.filter("src/com/daniel/crossword/dict/es.dic", "src/com/daniel/crossword/dict/es_filtered.dic", corpora);
		
		assertTrue(true);
	}
	
}
