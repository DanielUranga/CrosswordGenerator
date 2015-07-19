import com.daniel.crossword.Crossword;
import com.daniel.crossword.CrosswordGenerator;
import com.daniel.crossword.Direction;
import com.daniel.crossword.StringSet;
import com.daniel.crossword.StringUtil;

using Lambda;

class Main {

	static function main() {

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

		var crossword = CrosswordGenerator.genCrossword(testWords, 10);
		crossword.printCrossword();

	}

}
