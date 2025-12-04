import java.io.File

var lines = File("silver.txt").readLines()
// val lines = inputText.split("\n")

// println(lines.size); println(lines); readLine()

var sum: Int = 0

fun forkLift(lines: List<String>): List<String> {
  var newLine = ""

  for((row,line) in lines.withIndex()){
    // println("$row: $line")

    for((col, loc) in line.withIndex()){
      if(loc != '@') {
        newLine += loc
        continue
      }
      // println("  $col: $loc")

      // if loc has less than 4 adjacent spots, it can be accessed.
      var above = ""
      var left = ""
      var right = ""
      var below = ""

      // there is a row above, populate it.
      if(row > 0){
        if(col > 0) above += lines[row-1][col-1]
        above += lines[row-1][col]
        if(col+1 < line.length) above += lines[row-1][col+1]
      }

      if(col > 0) left += lines[row][col-1]
      if(col+1 < line.length) right += lines[row][col+1]

      if(row+1 < lines.size){
        if(col > 0) below += lines[row+1][col-1]
        below += lines[row+1][col]
        if(col+1 < line.length) below += lines[row+1][col+1]
      }

      // println("  | $above\n  | $left$loc$right\n  | $below")
      // println("$above$left$right$below")
      // println("$above$left$right$below".count { it == '@' })
      if("$above$left$right$below".count { it == '@' } < 4){
        sum+=1
        newLine += '.'
      } else {
        newLine += loc
      }
    }
    newLine += '|'
  }
  return newLine.dropLast(1).split('|')
}

var beforeSum = sum
do { 
  beforeSum = sum
  lines = forkLift(lines)
} while ( beforeSum != sum )

println("Final: $sum")
