import kotlin.io.path.Path
import kotlin.io.path.forEachLine
import kotlin.math.abs

class Dial() {
  var current: Int = 50
  val understand = Regex("(.)(\\d+)")

  fun spin (dir: String): Boolean {
    val instruction = Regex("(.)(\\d+)").find(dir)!!
    val (turn, dist) = instruction.destructured
    val distance = dist.toInt()

    val new = current + distance * (if (turn == "L") -1 else 1)

    current = if (new >= 0) new%100 else 100-(abs(new)%100)
    if (current == 100) current = 0

    println("Dial is now at ${current}")
    return current == 0
  }

  fun slowSpin (instruction: String): Int {
    val (turn, howFar) = understand.find(instruction)!!.destructured
    val distance = howFar.toInt()
    var passes = 0


    var temp = current

    for (i in 1..distance){
      temp = temp + 1 * (if (turn == "L") -1 else 1)
      temp = if (temp >= 0) temp%100 else 100-(abs(temp)%100)
      passes += if (temp == 0) 1 else 0
    }

    current = temp
    return passes
  }
}

val d = Dial()

val file = Path("silver.txt")
var counter = 0

fun linePrint(line: String){
  println(line)
  counter+= if (d.spin(line)) 1 else 0
}

fun slowSpinner(line: String){
  println(line)
  counter += d.slowSpin(line)
}

file.forEachLine(Charsets.UTF_8, ::slowSpinner)
println("...and now we have ${counter}")
