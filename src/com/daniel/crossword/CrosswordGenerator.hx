package com.daniel.crossword;

import com.daniel.crossword.Crossword;

class CrosswordGenerator {

	static function shuffle(arr : Array<String>) {
		for (i in 0...arr.length) {
			var j = Std.random(arr.length-1);
			var a = arr[i];
			var b = arr[j];
			arr[i] = b;
			arr[j] = a;
		}
	}

	public static function genCrossword(words : Array<String>, maxIter : Int) : Crossword {

		var sortedWords = words.copy();
		sortedWords.sort(function(x : String, y : String) return x.length<y.length ? 1 : -1);

		var currentBest = new Crossword();
		var s = StringSet.fromArray(sortedWords);
		for (w in sortedWords) {
			var arr = currentBest.getWordPositionsScores(w, s);
			var best = arr[0];
			for (a in arr) {
				if (a.score>best.score) {
					best = a;
				}
			}
			currentBest.putWord(best.pos, w);
			s.remove(w);
		}

		for (i in 0...maxIter) {
			var crossword = new Crossword();
			shuffle(sortedWords);
			var s = StringSet.fromArray(sortedWords);
			for (w in sortedWords) {
				var wordPos : Array<WordPositionScore> = crossword.getWordPositionsScores(w, s);
				var filteredWordPos = [];
				Lambda.iter(wordPos, function(w) if (w.score>=100) filteredWordPos.push(w));
				if (filteredWordPos.length==0) {
					Lambda.iter(wordPos, function(w) filteredWordPos.push(w));
				}
				var rndPos = filteredWordPos[Std.random(filteredWordPos.length)];
				crossword.putWord(rndPos.pos, w);
				s.remove(w);
			}
			if (crossword.score()>currentBest.score()) {
				currentBest = crossword;
			}
		}

		return currentBest;

	}


}
