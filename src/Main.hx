import com.daniel.crossword.Crossword;
import com.daniel.crossword.Direction;
import com.daniel.crossword.StringSet;

class Main {

	static function main() {
		
		var s = new StringSet();
		var crossword = new Crossword();

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

		testWords.sort(function(x : String, y : String) return x.length<y.length ? 1 : -1);

		trace(testWords);

		for (w in testWords) {
			s.put(w);
		}
		
		for (w in testWords) {
			var arr = crossword.getWordPositionsScores(w, s);
			var best = arr[0];
			for (a in arr) {
				if (a.score>best.score) {
					best = a;
				}
			}
			crossword.putWord(best.pos, w);
			s.remove(w);
		}
		
		#if js
		js.Browser.document.getElementById("haxe:trace").innerHTML = crossword.toString();
		#else
		trace(crossword);
		#end
	}

}
