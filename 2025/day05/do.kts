import kotlin.io.path.Path
import kotlin.io.path.forEachLine

// val file = Path("example.txt")
val file = Path("silver.txt")

var freshStuff: MutableList<Array<Long>> = mutableListOf()
var freshRanges: MutableList<LongRange> = mutableListOf()
var isFreshListing = true
var areFresh = 0
var sum: Long = 0

fun gold(line: String){
  if(line == "") {
    isFreshListing = false
    return
  }
  if(isFreshListing == false) return
  println(line)

  var (start, end) = line.split('-').map { it.toLong() }
  // freshRanges.add(start..end)
  var isKnown = false
  
  var meld = true
  while (meld) {
    meld = false
    for((i, r) in freshRanges.withIndex()) {
      if(start <= r.last && end >= r.start){
        start = minOf(start, r.start)
        end = maxOf(end, r.last)
        freshRanges.removeAt(i)
        meld = true
        break
      }
    }
  }
  freshRanges.add(start..end)
}

fun silver(line: String){
  println(line)

  if(line == ""){
    isFreshListing = false
    return
  }

  if (isFreshListing) {
    val (start, end) = line.split('-').map { it.toLong() }
    freshStuff.add(arrayOf(start, end))
  } else {
    // if(freshStuff.contains(line.toLong())) areFresh += 1
    println("checking fresh of $line")
    var isFresh = false
    for((s,e) in freshStuff){
      if(line.toLong() in s..e){
        areFresh +=1 
        return
      }
    }
  }
}

// file.forEachLine(Charsets.UTF_8, ::silver)
file.forEachLine(Charsets.UTF_8, ::gold)

for(r:LongRange in freshRanges) {
  println("Start at ${r.first} to ${r.last}")
  sum += r.last-r.first+1
}

println("$areFresh are fresh.")
println("$sum is the total.")
