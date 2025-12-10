import kotlin.io.path.Path
import kotlin.io.path.forEachLine

val file = Path("example.txt")
// val file = Path("silver.txt")

var grid: MutableList<MutableList<String>> = mutableListOf<MutableList<String>>()

fun makeGrid(line: String){
  val arr = line.trim().split("\\s+".toRegex()).toMutableList()
  grid.add(arr)
}

file.forEachLine(Charsets.UTF_8, ::makeGrid)

var grandTotal: Long = 0
// Silver!

for(c in grid.get(0).indices){
  // println(c)
  var data: MutableList<String> = mutableListOf<String>()
  for(r in grid.indices){
    // println("  $r: ${grid.get(r).get(c)}")
    data.add(grid.get(r).get(c))
  }
  val last = data.last()
  // println(last)
  data = data.dropLast(1).toMutableList()
  // println(data)

  if(last == "*"){
    // println("add sum ${data.map{ it.toLong()}.reduce{acc, v -> acc*v}}")
    grandTotal += data.map{ it.toLong()}.reduce{acc, v -> acc *v}
  } else if (last == "+"){
    // println("add sum ${data.map{ it.toLong()}.sum()}")
    grandTotal += data.map{ it.toLong()}.sum()
  } else{
    println("OH NO: $last")
  }
}

println("with grand total: $grandTotal")
