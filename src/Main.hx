import com.daniel.crossword.Crossword;
import com.daniel.crossword.CrosswordGenerator;
import com.daniel.crossword.Direction;
import com.daniel.crossword.StringSet;

class Main {

	static function main() {
		/*
		var crossword = new Crossword();
		*/
		var testWords = [
			"kiko",
			"comenico",
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

		var crossword = CrosswordGenerator.genCrossword(testWords, 100);
		crossword.printCrossword();

	}

}
