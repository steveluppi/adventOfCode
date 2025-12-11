import java.io.File

val ANSI_RED = "\u001b[31m"
val ANSI_GREEN = "\u001b[32m"
val ANSI_RESET = "\u001b[0m"

val lines = File("silver.txt").readLines()
// val lines = File("example.txt").readLines()
val start = lines[0].indexOf('S')
val ending = lines.indices.max()

var knownPaths = mutableMapOf<String, Long>()

class Thing(initRow: Int, initCol: Int) {
  var row: Int = initRow
  var col: Int = initCol

  fun total(): Long {
    // println("Looking for a total of ${toString()}")
    // if we are at the end - return 1
    // println("  does it go to end ${goesToEnd()}")
    // println("  is at the end ${row == ending}")
    if(row == ending || goesToEnd()) return 1L

    // if we have a known total - just use it
    val knownTotal = knownPaths[toString()]
    // println("  knownTotal is $knownTotal")
    if(knownTotal == null) {
      // println("  Not known, let's traverse")
      val sr = splitAt()
      // println("  going to have to split at $sr")
      val l = Thing(sr, col-1).total()
      val r = Thing(sr, col+1).total()
      knownPaths[toString()] = l+r
      return l + r
    } else {
      // println("  IS KNOWN")
      return knownTotal
    }
  }

  fun splitAt(): Int {
    var r = row + 1
    while(r < ending){
      if(lines[r][col] == '.'){
        r += 1
      } else if (lines[r][col] == '^') {
        return r
      }
    }
    throw Error("oh no")
  }

  fun goesToEnd(): Boolean {
    // println("goesToEnd() of ${toString()}")
    var r = row + 1
    while(r < ending){
      if(lines[r][col] == '.'){
        r += 1
      //   println("goesToEnd(): able to move forward to $r")
      } else if (lines[r][col] == '^') {
        // println("goesToeEnd(): we split here at $r")
        return false
      }
    }

    // println("goesToEnd(): We make it to the end")
    return true
  }

  override fun toString(): String{
    return "Thing<$row: $col>"
  }
}

val p = Thing(0, start)

println("We have a total of ${p.total()}")
