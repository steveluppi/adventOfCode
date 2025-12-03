import java.io.File
// import kotlin.io.path.Path
// import kotlin.io.path.forEachLine
// import kotlin.math.abs

// val input = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"
// val input = "1-11"
val input = File("silver.txt").readText()

val understanding = Regex("\\d+\\-\\d+")
val asRange = Regex("(\\d+)\\-(\\d+)")

val matches = understanding.findAll(input)!!

var sum:Long = 0
var theSet: MutableSet<Long> = mutableSetOf<Long>()
for (matchResult in matches) {
  // theSet.clear()
  // println("Match: ${matchResult.value}")
  val range = asRange.find(matchResult.value)!!
  val (start, end) = range.destructured
  // println("Starting ${start} and ending ${end}")
  val len = end.length
  val len_to_check = len/2
  for (i in start.toLong()..end.toLong()){
    val str = i.toString()
    // println("Iterate ${str} with len ${len} and len_to_check ${len_to_check}")

    for (j in 1..len_to_check){
      // println("Checking from 1 to ${j} which is ${str.substring(0,j)}")
      val parts = str.split(Regex(str.substring(0,j)))
      // for (m in parts){
      //   println("matches has ${m}")
      // }
      // if (parts.any { it.isNotEmpty()}) println("...nope...")
      if (parts.all { it.isEmpty()} && str.length>1) {
        // println(" *** WE FOUND THE THING: ${str}")
        theSet.add(i)
        // println(theSet)
        // println("Press Enter to continue"); readLine();
      }
    }
  }
  // println("Adding in $theSet")
}
for (v in theSet.sorted()) println(v)
sum += theSet.sumOf {it}


// for (matchResult in matches) {
//     println("Match: ${matchResult.value}")
//     val range = asRange.find(matchResult.value)!!
//     val (start, end) = range.destructured
//     println("Starting ${start} and ending ${end}")
//     for (i in start.toLong()..end.toLong()){
//       val str = i.toString()
//       if (str.length % 2 != 0) continue
//
//       val splitSize = str.length / 2
//
//       val a = str.substring(0,splitSize)
//       val b = str.substring(splitSize)
//
//       // println("Split string is ${a} and ${b}")
//       if (a==b) {
//         // println(" ... and it's a match")
//         sum += i
//       }
//     }
// }

println("ending with ${sum}")

if (sum >= 45814076275) println("NOPE!!! too high")
// val file = Path("silver.txt")
// var counter = 0

// fun linePrint(line: String){
//   println(line)
//   counter+= if (d.spin(line)) 1 else 0
// }
//
// fun slowSpinner(line: String){
//   println(line)
//   counter += d.slowSpin(line)
// }
//
// file.forEachLine(Charsets.UTF_8, ::slowSpinner)
// println("...and now we have ${counter}")
//
