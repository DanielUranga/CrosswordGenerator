package com.daniel.crossword;

import com.daniel.crossword.Direction;

typedef WordPositionScore = {pos:WordPosition, score:Int};

class CrosswordUtilInfiniteBoard {

	public static function getWordPositionsScores(crossword : Crossword, word : String, remainingWords : StringSet) : Array<WordPositionScore> {
		var ret = [];
		var x = 0;
		var y = 0;
		var wPos = new WordPosition(0, 0, S);
		for (dir in [S, E]) {
			for (y in crossword.minY-word.length-1...crossword.maxY+1) {
				for (x in crossword.minX-word.length-1...crossword.maxX+1) {
					if ((x<crossword.minX && dir==S) || (y<crossword.minY && dir==E)) {
						continue;
					}
					wPos.x = x;
					wPos.y = y;
					wPos.dir = dir;
					var score = croosword.putWordScore(wPos, word, remainingWords);
					if (score>=0) {
						ret.push({pos : wPos.copy(), score : score});
					}
				}
			}
		}
		return ret;
	}

}
