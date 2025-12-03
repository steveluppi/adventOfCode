import kotlin.io.path.Path
import kotlin.io.path.forEachLine

val file = Path("silver.txt")

var sum:Long = 0;

fun gold(line: String){
  println(line)
  val list = line.toMutableList()
  var max = line.substring(0,12).toLong()
  println("current string $max")
  for (i in 12..line.length-1){
    val new_char = line.substring(i,i+1)
    // println("char at $i is $new_char")
    val test = "$max$new_char"
    // println(" ... so the new test is $test")
    max = findMax(max, test)
    // println(" ... ... and we now have max $max")
  }
  println("and we tot o max $max")
  sum += max
}

fun findMax(max: Long, test: String): Long {
  var new = max

  for(i in 0..12){
    var testList = test.toMutableList()
    testList.removeAt(i)
    val attempt = testList.joinToString("").toLong()
    // println("attempt to try $attempt")
    new = if (attempt >= new) attempt else new
  }

  return new
}

fun linePrint(line: String){
  println(line)
  val list = line.toMutableList()
  var first = list.removeFirst(); var second = list.removeFirst()
  var result = "$first$second".toInt()
  println("First ${first} and second ${second}, as result $result")

  for(num in list) {
    // println("Checking $num, but have $first, $second, $result")
    val newFirst = "$first$num".toInt(); val newSecond = "$second$num".toInt();
    // println("New First $newFirst, and New Second = $newSecond")

    if((newFirst > newSecond) && (newFirst > result)){
      second = num; result = newFirst;
    } else if((newSecond >= newFirst) && (newSecond > result)){
      first = second; second = num; result = newSecond;
    }
  }

  println("biggest is $result")
  sum += result
}

file.forEachLine(Charsets.UTF_8, ::gold)

println("...totaling $sum")
