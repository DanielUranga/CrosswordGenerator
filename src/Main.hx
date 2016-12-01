import com.daniel.crossword.Corporae;
import com.daniel.crossword.Crossword;
import com.daniel.crossword.CrosswordUtilRestrictedBoard;
import com.daniel.crossword.Direction;
import com.daniel.crossword.StringSet;
import com.daniel.crossword.StringUtil;
import sys.io.File;

using Lambda;

class Main {

	static function main() {
		/*
		var testWords = [
			"ñandu",
			"kiko",
			"coménico",
			"chavo",
			"perro",
			"entropia",
			"mate",
			"xilofon",
			"camello",	
			"jirafa",
			"teclado",
			"oximoron",
			"otaku",
			"expresso"
		];
		testWords = testWords.map(function(str) return StringUtil.encode(str)).array();
		var set = new StringSet();
		for (w in testWords) {
			set.put(w);
		}

		var crossword = new Crossword();
		for (i in 0...50) {
			CrosswordUtilRestrictedBoard.tryAddRandomWord(crossword, 12, 12, set, Std.random(8)+3);
		}
		crossword.printCrossword();
		*/
		trace(1);
		var corpora = new Corporae();
		corpora.fromJson(File.getContent("src/com/daniel/crossword/corporae/wordfreqs.json"));
		trace(2);
		corpora.toString();
		var d = StringSet.fromUncompressedFile("src/com/daniel/crossword/dict/ES.dic", corpora);		
		trace(3);
		for (i in 0...10) {
			var c = CrosswordUtilRestrictedBoard.fillCrossword(12, 14, d);
			//Sys.println(c.toString());
			c.printCrossword();
			Sys.println('(${c.score()})');
		}

	}

}
