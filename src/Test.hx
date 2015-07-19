import com.daniel.crossword.tests.StringSetTest;
import haxe.unit.TestRunner;

class Test {

	static function main() {
		var r = new TestRunner();
		r.add(new StringSetTest());
		r.run();
	}
	
}
